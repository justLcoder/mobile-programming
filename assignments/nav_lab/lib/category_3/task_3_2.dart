import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: NameScreen()));
}

// Screen 1: Enter name
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Name')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GreetingScreen(name: name),
                    ),
                  );
                },
                child: const Text('Greet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen 2: Display greeting
class GreetingScreen extends StatelessWidget {
  final String name;

  const GreetingScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Greeting')),
      body: Center(
        child: Text('Hello, $name!', style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}
