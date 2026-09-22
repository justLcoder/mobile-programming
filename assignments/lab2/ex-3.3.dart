import 'dart:math';

void main() {
  int givenNumber = 1 + Random().nextInt(10);
  int factorial1 = 1;
  int factorial2 = 1;
  for (int i = 1; i <= givenNumber; i++) {
    factorial1 *= i;
  }
  for (int i in List.generate(givenNumber, (i) => i + 1)) {
    factorial2 *= i;
  }
  print('Given number is $givenNumber.');
  print(factorial1);
  print(factorial2);
}
