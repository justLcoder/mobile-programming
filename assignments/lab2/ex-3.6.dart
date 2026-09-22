void main() {
  dynamic response = {
    'status': 'success',
    'data': {'name': 'Shahzod', 'age': 19},
  };

  switch (response) {
    case {'status': 'success', 'data': var data}:
      print('Request successful');
      print(data);

    case {'status': 'error', 'error': var error}:
      print('Request failed');
      print(error);

    default:
      print('Unknown response');
  }
}
