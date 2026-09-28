class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class ApiFailure {
  final String message;

  ApiFailure(this.message);
}

class ApiClient {
  Future<String> fetchData() async {
    try {
      await Future.delayed(Duration(seconds: 1));

      throw NetworkException('Connection failed');
    } on NetworkException catch (e) {
      throw ApiFailure('API request failed: ${e.message}');
    }
  }
}

Future<void> main() async {
  final client = ApiClient();

  try {
    final result = await client.fetchData();
    print(result);
  } on ApiFailure catch (e) {
    print(e.message);
  }
}
