T getMax<T extends Comparable<T>>(T first, T second) {
  if (first.compareTo(second) > 0) {
    return first;
  } else {
    return second;
  }
}

void main() {
  print(getMax<int>(10, 20));
  print(getMax<String>('Apple', 'Banana'));
}
