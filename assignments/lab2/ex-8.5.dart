abstract class Animal {
  final String name;

  Animal(this.name);

  void makeSound();

  void introduce() {
    print('My name is $name.');
  }
}

class Dog extends Animal {
  Dog(super.name);

  @override
  void makeSound() {
    print('Woof!');
  }
}

class Cat extends Animal {
  Cat(super.name);

  @override
  void makeSound() {
    print('Meow!');
  }
}

void main() {
  final dog = Dog('Rocky');
  final cat = Cat('Luna');

  dog.introduce();
  dog.makeSound();

  cat.introduce();
  cat.makeSound();
}
