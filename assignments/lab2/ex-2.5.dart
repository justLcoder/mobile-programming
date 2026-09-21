import 'dart:ffi';

void main() {
  dynamic value;
  value = 'Shahzod';
  if (value is String) {
    print(value.toLowerCase());
  }
  value = 19;
  if (value is int) {
    int nextYearAge = value + 1;
    print('My age is $value. And next year I will turn $nextYearAge.');
  }
  value = 3.14;
  if (value is double) {
    print('Constant pi: $value');
  }
}
