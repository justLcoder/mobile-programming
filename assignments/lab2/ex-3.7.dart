void main() {
  List<String> appStates = [
    'starting',
    'loading',
    'running',
    'paused',
    'stopped',
  ];

  for (String state in appStates) {
    print('Application state: $state');

    if (state == 'running') {
      print('Application is ready');
    }

    if (state == 'stopped') {
      print('Application closed');
    }
  }
}
