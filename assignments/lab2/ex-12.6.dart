void processData() {
  try {
    throw FormatException('Invalid data');
  } catch (e) {
    print('Error inside processData: $e');

    rethrow;
  }
}

void main() {
  try {
    processData();
  } catch (e) {
    print('Error handled in main: $e');
  }
}
