import 'package:flutter/foundation.dart';

import '../models/history_entry.dart';
import 'classifier.dart';

/// The one shared object: the classifier loaded at start-up and the session
/// history. Passed to screens through their constructors.
class AppState extends ChangeNotifier {
  AppState(this.classifier);

  final Classifier classifier;
  final List<HistoryEntry> _history = [];

  /// Newest first.
  List<HistoryEntry> get history => _history.reversed.toList(growable: false);

  HistoryEntry? get latest => _history.isEmpty ? null : _history.last;

  /// The single classification path for every source:
  /// bytes -> classify -> history entry. Throws [FormatException] for bad bytes.
  HistoryEntry classifyAndRecord(Uint8List bytes, PictureSource source) {
    final watch = Stopwatch()..start();
    final predictions = classifier.classify(bytes);
    watch.stop();
    debugPrint('classify() took ${watch.elapsedMilliseconds} ms');

    final entry = HistoryEntry(
      bytes: bytes,
      predictions: predictions,
      source: source,
      time: DateTime.now(),
      elapsedMs: watch.elapsedMilliseconds,
    );
    _history.add(entry);
    notifyListeners();
    return entry;
  }
}
