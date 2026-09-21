void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    Map<String, String> flags = {};
    List<String> temp_key_value;
    for (String argument in arguments) {
      if (argument.startsWith('--') &&
          argument.contains('=') &&
          argument[2] != '=' &&
          !argument.endsWith('=')) {
        temp_key_value = argument.split('=');
        flags[temp_key_value[0].substring(2)] = temp_key_value[1];
      }
    }
    print(flags);
  }
}
