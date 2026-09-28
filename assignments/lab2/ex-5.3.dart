class Validator {
  /// Checks whether [age] is within the valid range.
  ///
  /// Returns `true` if [age] is between 0 and 120.
  ///
  /// Throws an [ArgumentError] if [age] is negative.
  bool isValidAge(int age) {
    if (age < 0) {
      throw ArgumentError('Age cannot be negative.');
    }

    return age <= 120;
  }

  /// Checks whether [email] contains the `@` symbol.
  ///
  /// Returns `true` if the email format is valid.
  ///
  /// Throws an [ArgumentError] if [email] is empty.
  bool isValidEmail(String email) {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    return email.contains('@');
  }
}

void main() {
  final validator = Validator();

  print(validator.isValidAge(19));
  print(validator.isValidEmail('student@example.com'));
}
