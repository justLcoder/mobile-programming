abstract class PaymentStrategy {
  void pay(double amount);
}

class CardPayment implements PaymentStrategy {
  @override
  void pay(double amount) {
    print('Paid \$$amount using card');
  }
}

class CashPayment implements PaymentStrategy {
  @override
  void pay(double amount) {
    print('Paid \$$amount using cash');
  }
}

class Checkout {
  final PaymentStrategy strategy;

  Checkout(this.strategy);

  void process(double amount) {
    strategy.pay(amount);
  }
}

void main() {
  final cardCheckout = Checkout(CardPayment());
  cardCheckout.process(100);

  final cashCheckout = Checkout(CashPayment());
  cashCheckout.process(50);
}
