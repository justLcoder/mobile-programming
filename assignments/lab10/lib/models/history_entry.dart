import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/classifier.dart';

/// Where the picture came from. Only the way the bytes arrive differs.
enum PictureSource {
  camera('Camera', Icons.photo_camera_outlined),
  gallery('Gallery', Icons.photo_library_outlined),
  download('Download', Icons.cloud_download_outlined);

  const PictureSource(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// One classification: the picture, its predictions and where it came from.
class HistoryEntry {
  const HistoryEntry({
    required this.bytes,
    required this.predictions,
    required this.source,
    required this.time,
    required this.elapsedMs,
  });

  final Uint8List bytes;
  final List<Prediction> predictions; // sorted, highest first
  final PictureSource source;
  final DateTime time;
  final int elapsedMs; // how long classify() took

  Prediction get top => predictions.first;
}
