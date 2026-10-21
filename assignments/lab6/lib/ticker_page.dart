import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/ticker_providers.dart';
import 'widgets/tick_row.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticks = ref.watch(tickerProvider);

    Widget tickList(List<dynamic> values) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [for (final t in values) TickRow(t, key: ValueKey(t.symbol))],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live ticker'),
        actions: [
          IconButton(
            tooltip: 'Simulate error',
            icon: const Icon(Icons.wifi_off),
            onPressed: () {
              ref.read(failAfterProvider.notifier).state = 5;
            },
          ),
          IconButton(
            tooltip: 'Restore feed',
            icon: const Icon(Icons.wifi),
            onPressed: () {
              ref.read(failAfterProvider.notifier).state = null;
              ref.invalidate(tickerProvider);
            },
          ),
        ],
      ),
      body: switch (ticks) {
        AsyncError(:final error, :final value?) => Column(
          children: [
            MaterialBanner(
              content: Text('Feed error: $error — showing last prices'),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(failAfterProvider.notifier).state = null;
                    ref.invalidate(tickerProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
            Expanded(child: Opacity(opacity: 0.5, child: tickList(value))),
          ],
        ),

        AsyncError(:final error) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load ticker\n$error'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  ref.read(failAfterProvider.notifier).state = null;
                  ref.invalidate(tickerProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        AsyncValue(:final value?, isLoading: true) => Column(
          children: [
            const LinearProgressIndicator(),
            Expanded(child: tickList(value)),
          ],
        ),

        AsyncData(value: []) => const Center(
          child: Text('No symbols subscribed'),
        ),

        AsyncData(value: [final only]) => Center(child: TickRow(only)),

        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.refresh(tickerProvider.future),
          child: tickList(value),
        ),

        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
