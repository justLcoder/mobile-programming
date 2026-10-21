import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ticker_page.dart';

void main() {
  runApp(
    ProviderScope(retry: (retryCount, error) => null, child: const TickerApp()),
  );
}

class TickerApp extends StatelessWidget {
  const TickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticker',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const TickerPage(),
    );
  }
}
