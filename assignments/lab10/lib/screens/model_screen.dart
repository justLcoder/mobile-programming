import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../services/classifier.dart';
import '../theme/app_theme.dart';
import '../widgets/feedback.dart';

/// Screen 5: what the model knows, plus the design credit.
class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key, required this.state});

  final AppState state;

  /// T12: feed classify() the bytes of a text file. It must end in a message.
  Future<void> _badInputTest(BuildContext context) async {
    final textFile = Uint8List.fromList(
      utf8.encode('This is a plain text file, not a picture.\n'),
    );
    try {
      state.classifier.classify(textFile);
    } on FormatException catch (e) {
      await showErrorDialog(
        context,
        title: 'Not a picture',
        message: '${e.message}\n(The bad-input test passed: no crash.)',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // Labels come from the loaded classifier: the exact list the model output
    // is paired with, read once from labels.txt at start-up.
    final labels = state.classifier.labels;

    Widget info(String name, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(value, style: theme.textTheme.titleSmall),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Model')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('About the model', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s),
                  info('Model file', Classifier.modelFileName),
                  info('Number of classes', '${labels.length}'),
                  info(
                    'Input size',
                    '${Classifier.inputSize} × ${Classifier.inputSize} × 3',
                  ),
                  info('Trained with', 'Teachable Machine'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Labels (from labels.txt)',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  for (var i = 0; i < labels.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: scheme.primaryContainer,
                            child: Text(
                              '$i',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Text(labels[i], style: theme.textTheme.bodyLarge),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          OutlinedButton.icon(
            onPressed: () => _badInputTest(context),
            icon: const Icon(Icons.bug_report_outlined),
            label: const Text('Run bad-input test'),
          ),
          const SizedBox(height: AppSpacing.m),
          Card(
            color: scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Design credit', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'UI based on "${DesignCredit.name}" by ${DesignCredit.author}, '
                    'Figma Community, licensed ${DesignCredit.licence}.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SelectableText(
                    DesignCredit.link,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
