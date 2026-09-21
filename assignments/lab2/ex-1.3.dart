void main(List<String> arguments) {
  int number_of_arguments = arguments.length;
  print('Hello, Dart World!');
  if (arguments.isNotEmpty) {
    print(
      'There are ' +
          number_of_arguments.toString() +
          ' command-line arguments passed.',
    );
    print('Command line arguments passed: ${arguments.join(', ')}');
  }
}
