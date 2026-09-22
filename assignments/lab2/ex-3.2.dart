import 'dart:math';

void main() {
  num givenNumber = -10 + Random().nextInt(21);
  if (givenNumber > 0) {
    print('The given number $givenNumber is positive.');
  } else if (givenNumber < 0) {
    print('The given number $givenNumber is negative.');
  } else
    (print('The given number $givenNumber is zero.'));
}
