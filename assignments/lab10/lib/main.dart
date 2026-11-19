import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'screens/welcome_screen.dart';
import 'services/app_state.dart';
import 'services/classifier.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TmClassifierApp());
}

/// T10 smoke test: classify assets/model/sample.jpg and print every label.
Future<void> smokeTest(Classifier classifier) async {
  const samplePath = 'assets/model/sample.jpg';
  try {
    final data = await rootBundle.load(samplePath);
    final predictions = classifier.classify(data.buffer.asUint8List());
    debugPrint('--- Smoke test: $samplePath ---');
    for (final p in predictions) {
      debugPrint('${p.label}: ${(p.confidence * 100).toStringAsFixed(1)} %');
    }
    final sum = predictions.fold<double>(0, (s, p) => s + p.confidence);
    debugPrint(
      '${predictions.length} labels, top: ${predictions.first.label}, '
      'sum = ${sum.toStringAsFixed(4)}',
    );
  } catch (e) {
    debugPrint('Smoke test skipped: $e');
  }
}

/// Loads the classifier once at start-up and shares it with every screen.
class TmClassifierApp extends StatefulWidget {
  const TmClassifierApp({super.key});

  @override
  State<TmClassifierApp> createState() => _TmClassifierAppState();
}

class _TmClassifierAppState extends State<TmClassifierApp> {
  AppState? _state;
  Object? _error;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onDetach: _close);
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final classifier = await Classifier.load();
      if (kDebugMode) await smokeTest(classifier);
      if (!mounted) {
        classifier.close();
        return;
      }
      setState(() => _state = AppState(classifier));
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _close() {
    _state?.classifier.close();
    _state = null;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: WelcomeScreen(state: _state, error: _error, onRetry: _load),
    );
  }
}
