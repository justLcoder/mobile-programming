void main(List<String> arguments) {
  int number_of_arguments = arguments.length;
  print('Hello, Dart World!');
  if (arguments.isNotEmpty) {
    int sum = 0;
    for (String number in arguments) {
      sum += int.parse(number);
    }

    print(sum / arguments.length);
  }
}
