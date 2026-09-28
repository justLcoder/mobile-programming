/// Represents a user in the application.
class User {
  /// The unique identifier of the user.
  final int id;

  /// The user's name.
  final String name;

  /// Creates a new [User].
  ///
  /// The [id] must be positive and [name] must not be empty.
  User({required this.id, required this.name}) {
    if (id <= 0) {
      throw ArgumentError('ID must be positive.');
    }

    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty.');
    }
  }
}

/// Provides operations for managing [User] objects.
class UserService {
  final List<User> _users = [];

  /// Adds [user] to the collection.
  void addUser(User user) {
    _users.add(user);
  }

  /// Finds a user whose ID equals [id].
  ///
  /// Returns the matching [User].
  ///
  /// Throws a [StateError] if no user with [id] exists.
  User getUserById(int id) {
    return _users.firstWhere(
      (user) => user.id == id,
      orElse: () => throw StateError('User not found.'),
    );
  }

  /// Returns all currently stored users.
  List<User> getAllUsers() {
    return List.unmodifiable(_users);
  }
}

void main() {
  final service = UserService();

  service.addUser(User(id: 1, name: 'Alice'));

  final user = service.getUserById(1);

  print(user.name);
}
