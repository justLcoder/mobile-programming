import 'package:flutter/material.dart';

import '../services/classifier.dart';
import '../theme/app_theme.dart';

/// "86.4 %" from 0.864.
String formatPercent(double confidence) =>
    '${(confidence * 100).toStringAsFixed(1)} %';

/// One label row: name, bar and percentage. The top row is emphasised.
class PredictionRow extends StatelessWidget {
  const PredictionRow({super.key, required this.prediction, this.isTop = false});

  final Prediction prediction;
  final bool isTop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = isTop
        ? theme.textTheme.titleSmall?.copyWith(color: scheme.primary)
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              prediction.label,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              child: LinearProgressIndicator(
                value: prediction.confidence.clamp(0.0, 1.0),
                minHeight: isTop ? AppSpacing.s + 2 : AppSpacing.s - 2,
                color: isTop ? scheme.primary : scheme.secondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          SizedBox(
            width: 64,
            child: Text(
              formatPercent(prediction.confidence),
              style: style,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
