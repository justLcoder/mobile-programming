List<int> transformNumbers(List<int> numbers, int Function(int) transformer) {
  List<int> result = [];

  for (int number in numbers) {
    result.add(transformer(number));
  }

  return result;
}

void main() {
  List<int> numbers = [1, 2, 3, 4, 5];

  List<int> result = transformNumbers(numbers, (number) => number * 2);

  print(result);
}
