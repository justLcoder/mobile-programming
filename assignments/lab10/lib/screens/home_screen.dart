import 'package:flutter/material.dart';

import '../models/history_entry.dart';
import '../services/app_state.dart';
import '../services/image_sources.dart';
import '../theme/app_theme.dart';
import '../widgets/classify_flow.dart';
import '../widgets/prediction_row.dart';
import 'result_screen.dart';

/// Screen 2: the three sources and the most recent result.
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.state, required this.onOpenHistory});

  final AppState state;
  final VoidCallback onOpenHistory;
  final _sources = ImageSources();

  Future<void> _camera(BuildContext context) => classifyFrom(
        context,
        state: state,
        source: PictureSource.camera,
        getBytes: _sources.fromCamera,
      );

  Future<void> _gallery(BuildContext context) => classifyFrom(
        context,
        state: state,
        source: PictureSource.gallery,
        getBytes: _sources.fromGallery,
      );

  Future<void> _download(BuildContext context) async {
    final url = await showDialog<String>(
      context: context,
      builder: (_) => const _UrlDialog(),
    );
    if (url == null || !context.mounted) return;
    await classifyFrom(
      context,
      state: state,
      source: PictureSource.download,
      getBytes: () => _sources.fromUrl(url),
      loadingMessage: 'Downloading the image…',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          Text('Hello!', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'What should we recognise today?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _ActionCard(
            icon: PictureSource.camera.icon,
            title: 'Take a photo',
            subtitle: 'Use the phone camera',
            highlighted: true,
            onTap: () => _camera(context),
          ),
          const SizedBox(height: AppSpacing.m),
          _ActionCard(
            icon: PictureSource.gallery.icon,
            title: 'Choose from gallery',
            subtitle: 'Pick a picture already on the phone',
            onTap: () => _gallery(context),
          ),
          const SizedBox(height: AppSpacing.m),
          _ActionCard(
            icon: PictureSource.download.icon,
            title: 'Download an image',
            subtitle: 'Paste the address of a picture on the web',
            onTap: () => _download(context),
          ),
          const SizedBox(height: AppSpacing.xl),
          ListenableBuilder(
            listenable: state,
            builder: (context, _) => _LatestResult(
              entry: state.latest,
              onOpenHistory: onOpenHistory,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = highlighted ? scheme.onPrimary : scheme.onSurface;
    return Card(
      color: highlighted ? scheme.primary : scheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    highlighted ? scheme.onPrimary : scheme.primaryContainer,
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: AppSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(color: fg),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: highlighted
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestResult extends StatelessWidget {
  const _LatestResult({required this.entry, required this.onOpenHistory});

  final HistoryEntry? entry;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = entry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Latest result', style: theme.textTheme.titleMedium),
            ),
            if (e != null)
              TextButton(onPressed: onOpenHistory, child: const Text('See all')),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        Card(
          child: e == null
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Text(
                    'No pictures yet. Your most recent result will appear here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListTile(
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
                    '${formatPercent(e.top.confidence)} · ${e.source.label}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ResultScreen(entry: e),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _UrlDialog extends StatefulWidget {
  const _UrlDialog();

  @override
  State<_UrlDialog> createState() => _UrlDialogState();
}

class _UrlDialogState extends State<_UrlDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Download an image'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.go,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(
          hintText: 'https://example.com/picture.jpg',
          prefixIcon: Icon(Icons.link),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Download')),
      ],
    );
  }
}
