import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bloc/cart_page_bloc.dart';
import 'cubit/cart_page_cubit.dart';
import 'riverpod/cart_page_riverpod.dart';
import 'setstate/cart_page_setstate.dart';

void main() => runApp(const ProviderScope(child: App()));

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Cart Four Ways',
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const HomePage(),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = <String, Widget>{
      'setState': SetStateCartPage(),
      'Riverpod': RiverpodCartPage(),
      'Cubit': CubitCartPage(),
      'Bloc': BlocCartPage(),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('One Cart, Four Ways')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in pages.entries)
              Padding(
                padding: const EdgeInsets.all(8),
                child: FilledButton(
                  onPressed: () =>
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => e.value)),
                  child: Text(e.key),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
