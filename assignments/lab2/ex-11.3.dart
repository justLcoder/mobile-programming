Future<String> fetchUser() async {
  await Future.delayed(Duration(seconds: 1));
  return 'User loaded';
}

Future<String> fetchPosts() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Posts loaded';
}

Future<String> fetchComments() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Comments loaded';
}

Future<void> main() async {
  final results = await Future.wait([
    fetchUser(),
    fetchPosts(),
    fetchComments(),
  ]);

  for (final result in results) {
    print(result);
  }
}
