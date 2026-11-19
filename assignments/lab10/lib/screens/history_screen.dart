import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/feedback.dart';
import '../widgets/prediction_row.dart';
import 'result_screen.dart';

/// Screen 4: every classification of this session, newest first.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.state});

  final AppState state;

  String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final entries = state.history;
          if (entries.isEmpty) {
            return const StateMessage(
              icon: Icons.photo_size_select_actual_outlined,
              title: 'Nothing here yet',
              message: 'Every picture you classify in this session shows up '
                  'here, newest first. Start from the Home tab.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.l),
            itemCount: entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.m),
            itemBuilder: (context, i) {
              final e = entries[i];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(AppSpacing.m),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    child: Image.memory(
                      e.bytes,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      cacheWidth: 168,
                    ),
                  ),
                  title: Text(e.top.label, style: theme.textTheme.titleMedium),
                  subtitle: Text(
                    '${formatPercent(e.top.confidence)} · ${_time(e.time)}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(e.source.icon, color: theme.colorScheme.primary),
                      Text(e.source.label, style: theme.textTheme.labelSmall),
                    ],
                  ),
                  // Reopens the stored result; the model does not run again.
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ResultScreen(entry: e),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
