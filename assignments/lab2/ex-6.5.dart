class BankAccount {
  double _balance = 0;

  double get balance => _balance;

  set balance(double value) {
    if (value < 0) {
      throw ArgumentError('Balance cannot be negative.');
    }

    _balance = value;
  }
}

void main() {
  final account = BankAccount();

  account.balance = 500;

  print(account.balance);
}
