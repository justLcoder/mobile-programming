class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});
}

void main() {
  const user = User(id: 1, name: 'Shahzod', email: 'shahzod@example.com');

  print(user.name);
}
