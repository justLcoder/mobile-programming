Stream<int> numbers() async* {
  yield 1;
  yield 2;
  yield 2;
  yield 3;
  yield 4;
}

Future<void> main() async {
  final stream = numbers()
      .where((number) => number.isEven)
      .map((number) => number * 10)
      .distinct();

  await for (final value in stream) {
    print(value);
  }
}
