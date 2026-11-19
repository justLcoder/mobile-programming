import 'package:flutter/material.dart';

import '../models/history_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/prediction_row.dart';

/// Screen 3: the same widget for camera, gallery, download and History.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.entry});

  final HistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxImageHeight = MediaQuery.sizeOf(context).height * 0.45;
    final shownTotal = entry.predictions.fold<double>(
      0,
      (sum, p) => sum + double.parse((p.confidence * 100).toStringAsFixed(1)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.l),
            child: Chip(
              avatar: Icon(entry.source.icon, size: 18, color: scheme.primary),
              label: Text(entry.source.label),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.l),
          children: [
            // The supplied image, centred, uncropped, at most ~half the screen.
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxImageHeight),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: Image.memory(entry.bytes, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Looks like: ${entry.top.label}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    for (var i = 0; i < entry.predictions.length; i++)
                      PredictionRow(
                        prediction: entry.predictions[i],
                        isTop: i == 0,
                      ),
                    const Divider(height: AppSpacing.xl),
                    Text(
                      'Total ${shownTotal.toStringAsFixed(1)} % · '
                      '${entry.predictions.length} labels · '
                      'classified in ${entry.elapsedMs} ms',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
