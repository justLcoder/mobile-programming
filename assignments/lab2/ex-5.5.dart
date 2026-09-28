class User {
  /// Returns the user's name.
  ///
  /// This method is deprecated. Use [getFullName] instead.
  @Deprecated('Use getFullName() instead.')
  String getName() {
    return 'Shahzod';
  }

  /// Returns the user's full name.
  String getFullName() {
    return 'Shahzod Student';
  }

  /// Returns a readable representation of this user.
  @override
  String toString() {
    return getFullName();
  }
}

void main() {
  final user = User();

  print(user.getFullName());
  print(user);
}
