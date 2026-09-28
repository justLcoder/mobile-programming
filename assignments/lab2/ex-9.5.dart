class Animal {
  void eat() {
    print('Eating');
  }
}

mixin Flyer on Animal {
  void fly() {
    print('Flying');
  }
}

class Bird extends Animal with Flyer {}

void main() {
  final bird = Bird();

  bird.eat();
  bird.fly();
}
