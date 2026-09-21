void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    if (arguments.length != 2) {
      print(
        "Warning: Number of command-line arguments passed is not 2! Please provide 2 command-line arguments!",
      );
    }
  }
}
