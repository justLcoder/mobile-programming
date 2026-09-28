class Vehicle {
  final String brand;

  Vehicle(this.brand);

  void start() {
    print('$brand is starting...');
  }
}

class ElectricCar extends Vehicle {
  final int batteryCapacity;

  ElectricCar(super.brand, this.batteryCapacity);

  @override
  void start() {
    super.start();
    print('Battery capacity: $batteryCapacity kWh');
  }
}

void main() {
  final car = ElectricCar('Tesla', 75);

  car.start();
}
