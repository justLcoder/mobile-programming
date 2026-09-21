void main() {
  var mutableName = 'Alice';
  final String birthCity = 'Tashkent';
  const double pi = 3.14159;
  late String lazyDescription;

  lazyDescription = 'Initialized later!';

  final time1 = DateTime.now();
  const time2 = DateTime.now();
  print(time1);
  print(time2);

  /*This program gives an error, because we're assigning DateTime.now() to const, but const can only be assigned at compile time and cannot be changed later, while final works similarly too but we can assign final a value at runtime, so assigning DateTime.now() to final makes more sense and is correct way of doing it. */
}
