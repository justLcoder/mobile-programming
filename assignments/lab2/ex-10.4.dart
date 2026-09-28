class Repository<T> {
  final List<T> _items = [];

  void add(T item) {
    _items.add(item);
  }

  List<T> getAll() {
    return List.unmodifiable(_items);
  }
}

void main() {
  final nameRepository = Repository<String>();
  nameRepository.add('Alice');
  nameRepository.add('Bob');

  final numberRepository = Repository<int>();
  numberRepository.add(10);
  numberRepository.add(20);

  print(nameRepository.getAll());
  print(numberRepository.getAll());
}
