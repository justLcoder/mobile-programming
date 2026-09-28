enum Role { admin, student, teacher }

Role? parseRole(String value) {
  try {
    return Role.values.byName(value);
  } catch (_) {
    return null;
  }
}

void main() {
  final role1 = parseRole('student');
  final role2 = parseRole('manager');

  print(role1);
  print(role2);
}
