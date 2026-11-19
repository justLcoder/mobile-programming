import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/history_entry.dart';
import '../screens/result_screen.dart';
import '../services/app_state.dart';
import '../services/image_sources.dart';
import 'feedback.dart';

/// The one path every source goes through:
/// get bytes -> classify -> add to history -> open the Result screen.
///
/// [getBytes] returns null when the user cancelled (nothing happens then).
/// [loadingMessage], if given, shows a progress dialog while bytes arrive.
Future<void> classifyFrom(
  BuildContext context, {
  required AppState state,
  required PictureSource source,
  required Future<Uint8List?> Function() getBytes,
  String? loadingMessage,
}) async {
  final navigator = Navigator.of(context);

  // 1. Get the bytes.
  Uint8List? bytes;
  VoidCallback? closeLoading =
      loadingMessage == null ? null : showLoadingDialog(context, loadingMessage);
  try {
    bytes = await getBytes();
  } on ImageDownloadException catch (e) {
    closeLoading?.call();
    if (context.mounted) {
      await showErrorDialog(context, title: 'Download failed', message: e.message);
    }
    return;
  } catch (e) {
    closeLoading?.call();
    if (context.mounted) {
      await showErrorDialog(
        context,
        title: 'Could not get the picture',
        message: '$e',
      );
    }
    return;
  }
  closeLoading?.call();
  if (bytes == null || !context.mounted) return; // cancelled: stay where we are

  // 2. Classify (shared for all sources).
  closeLoading = showLoadingDialog(context, 'Classifying…');
  // Give the dialog one frame to appear before the model blocks the UI thread.
  await Future<void>.delayed(const Duration(milliseconds: 50));
  final HistoryEntry entry;
  try {
    entry = state.classifyAndRecord(bytes, source);
  } on FormatException catch (e) {
    closeLoading();
    if (context.mounted) {
      await showErrorDialog(context, title: 'Not a picture', message: e.message);
    }
    return;
  } catch (e) {
    closeLoading();
    if (context.mounted) {
      await showErrorDialog(
        context,
        title: 'Classification failed',
        message: '$e',
      );
    }
    return;
  }
  closeLoading();

  // 3. Show the result.
  await navigator.push(
    MaterialPageRoute<void>(builder: (_) => ResultScreen(entry: entry)),
  );
}
