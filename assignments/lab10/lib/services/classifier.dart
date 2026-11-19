import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Prediction {
  const Prediction(this.label, this.confidence);
  final String label;
  final double confidence; // 0.0 to 1.0
}

/// "0 Mug\n1 Bottle\n" becomes ['Mug', 'Bottle']. Pure, so it is unit-testable.
List<String> parseLabels(String raw) => [
      for (final line in raw.split('\n'))
        if (line.trim().isNotEmpty)
          line.trim().replaceFirst(RegExp(r'^\d+\s+'), ''),
    ];

/// Thrown when the model or labels cannot be loaded at start-up.
class ClassifierLoadException implements Exception {
  const ClassifierLoadException(this.what, this.path, this.cause);
  final String what; // "Model file" or "Labels file"
  final String path; // where it was expected
  final Object cause;

  @override
  String toString() => '$what not found or unreadable.\n'
      'Expected at: $path\n'
      'Check the file exists and that pubspec.yaml lists assets/model/.\n\n'
      'Details: $cause';
}

class Classifier {
  Classifier._(this._interpreter, this.labels);

  final Interpreter _interpreter;
  final List<String> labels;

  static const inputSize = 224;
  static const modelPath = 'assets/model/model_unquant.tflite';
  static const labelsPath = 'assets/model/labels.txt';
  static String get modelFileName => modelPath.split('/').last;

  static Future<Classifier> load() async {
    final Interpreter interpreter;
    try {
      interpreter = await Interpreter.fromAsset(modelPath);
    } catch (e) {
      throw ClassifierLoadException('Model file', modelPath, e);
    }
    final List<String> labels;
    try {
      labels = parseLabels(await rootBundle.loadString(labelsPath));
    } catch (e) {
      interpreter.close();
      throw ClassifierLoadException('Labels file', labelsPath, e);
    }
    return Classifier._(interpreter, labels);
  }

  /// Image bytes in, predictions sorted from highest to lowest out.
  /// Throws [FormatException] when the bytes are not a readable image.
  List<Prediction> classify(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const FormatException('This file is not a readable image.');
    }
    // Same centre square crop as Teachable Machine used for training.
    final square = img.copyResizeCropSquare(
      img.bakeOrientation(decoded),
      size: inputSize,
    );

    // Shape [1, 224, 224, 3], each channel mapped from 0..255 to -1..1.
    final input = [
      List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) {
          final p = square.getPixel(x, y);
          return [p.r / 127.5 - 1, p.g / 127.5 - 1, p.b / 127.5 - 1];
        }),
      ),
    ];
    // Shape [1, classes], same order as labels.txt.
    final output = [List<double>.filled(labels.length, 0)];
    _interpreter.run(input, output);

    // Pair index i with label i first, then sort.
    return [
      for (var i = 0; i < labels.length; i++)
        Prediction(labels[i], output.first[i]),
    ]..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  void close() => _interpreter.close();
}
