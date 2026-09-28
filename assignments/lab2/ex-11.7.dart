import 'dart:async';

Future<void> main() async {
  final controller = StreamController<String>.broadcast();

  controller.stream.listen((message) {
    print('Listener 1: $message');
  });

  controller.stream.listen((message) {
    print('Listener 2: $message');
  });

  controller.add('Hello');
  controller.add('New update available');

  await Future.delayed(Duration(milliseconds: 100));

  await controller.close();
}
