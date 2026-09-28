interface class DBConnector {
  void connect() {}

  void disconnect() {}
}

class MySQLConnector implements DBConnector {
  @override
  void connect() {
    print('Connected to MySQL database');
  }

  @override
  void disconnect() {
    print('Disconnected from MySQL database');
  }
}

void main() {
  final db = MySQLConnector();

  db.connect();
  db.disconnect();
}
