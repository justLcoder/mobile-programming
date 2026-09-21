void main() {
  String name = 'Shahzod';
  String? nickname;
  print(name);
  print(nickname ?? 'Unknown');
  nickname = 'Nick';
  print(name);
  print(nickname ?? 'Unknown');
}
