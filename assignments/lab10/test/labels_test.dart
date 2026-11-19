import 'package:flutter_test/flutter_test.dart';
import 'package:tm_classifier/services/classifier.dart';

void main() {
  test('parseLabels: normal case', () {
    expect(parseLabels('0 Mug\n1 Bottle\n'), ['Mug', 'Bottle']);
  });

  test('parseLabels: Windows line endings, blank line, label with a space', () {
    expect(
      parseLabels('0 Mug\r\n1 Bottle\r\n2 Car keys\r\n\r\n'),
      ['Mug', 'Bottle', 'Car keys'],
    );
  });
}
