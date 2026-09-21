typedef UserProfile = Map<String, dynamic>;

void main() {
  UserProfile user1 = {
    'name': 'Shahzod',
    'age': 19,
    'contact': {'email': 'example@gmail.com', 'phone': '+998-99-999-9999'},
  };
  print(user1);
}
