final class FinalVehicle {
  void move() {
    print('Final vehicle is moving');
  }
}

base class BaseVehicle {
  void move() {
    print('Base vehicle is moving');
  }
}

base class Car extends BaseVehicle {
  @override
  void move() {
    print('Car is moving');
  }
}

void main() {
  final vehicle = FinalVehicle();
  vehicle.move();

  final car = Car();
  car.move();
}
