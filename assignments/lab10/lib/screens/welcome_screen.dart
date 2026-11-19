import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/feedback.dart';
import 'home_shell.dart';

const appName = 'DeskLens';

/// Screen 1. Doubles as the loading screen while the model loads, and shows
/// what is missing (and where it was expected) if loading fails.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.state,
    required this.error,
    required this.onRetry,
  });

  final AppState? state; // null while loading
  final Object? error; // set when loading failed
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (error != null) {
      body = StateMessage(
        icon: Icons.report_gmailerrorred_outlined,
        title: 'The model could not be loaded',
        message: '$error',
        action: FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      );
    } else if (state == null) {
      body = const _Loading();
    } else {
      body = _Ready(state: state!);
    }
    return Scaffold(body: SafeArea(child: body));
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Logo(),
          const SizedBox(height: AppSpacing.xl),
          Text(appName, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xl),
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Loading the model…',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labels = state.classifier.labels;

    return Column(
      children: [
        // Green hero, like the Bloom splash screen.
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _Logo(onPrimary: true),
                const SizedBox(height: AppSpacing.l),
                Text(
                  appName,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: scheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.s,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Recognise the things on your desk',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Point the camera, pick a photo or paste an image link: '
                'the app tells you which of these ${labels.length} classes it '
                'sees, fully offline.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [for (final l in labels) Chip(label: Text(l))],
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => HomeShell(state: state),
                  ),
                ),
                child: const Text('Get started'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({this.onPrimary = false});

  final bool onPrimary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Icon(
      Icons.center_focus_strong_outlined,
      size: 72,
      color: onPrimary ? scheme.onPrimary : scheme.primary,
    );
  }
}
