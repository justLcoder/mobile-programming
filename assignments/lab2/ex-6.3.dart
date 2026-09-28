class Student {
  final String name;
  final int age;

  Student(String name, int age) : name = name.trim(), age = age {
    if (this.name.isEmpty) {
      throw ArgumentError('Name cannot be empty.');
    }

    if (age < 16 || age > 100) {
      throw ArgumentError('Age must be between 16 and 100.');
    }
  }
}

void main() {
  final student = Student('Shahzod', 19);

  print(student.name);
  print(student.age);
}
