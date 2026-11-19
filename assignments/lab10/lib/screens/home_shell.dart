import 'package:flutter/material.dart';

import '../services/app_state.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'model_screen.dart';

/// Bottom navigation for Home, History and Model.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.state});

  final AppState state;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Back on History or Model goes to Home first, then leaves the app.
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _index = 0);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            HomeScreen(
              state: widget.state,
              onOpenHistory: () => setState(() => _index = 1),
            ),
            HistoryScreen(state: widget.state),
            ModelScreen(state: widget.state),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history),
              selectedIcon: Icon(Icons.history_toggle_off),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.memory_outlined),
              selectedIcon: Icon(Icons.memory),
              label: 'Model',
            ),
          ],
        ),
      ),
    );
  }
}
