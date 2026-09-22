Function createCounter() {
  int count = 0;

  return () {
    count++;
    return count;
  };
}

void main() {
  Function counter = createCounter();

  print(counter());
  print(counter());
  print(counter());
}
