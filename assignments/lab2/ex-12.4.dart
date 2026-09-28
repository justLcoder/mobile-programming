void checkValue(dynamic value) {
  if (value is! int) {
    throw FormatException('Value must be an integer');
  }

  if (value < 0) {
    throw ArgumentError('Value cannot be negative');
  }
}

void main() {
  try {
    checkValue('hello');
  } on FormatException catch (e) {
    print('Format error: $e');
  } on ArgumentError catch (e) {
    print('Argument error: $e');
  } catch (e) {
    print('Unknown error: $e');
  }
}
