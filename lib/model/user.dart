class User {
  final String id;
  final String username;

  User({
    this.id,
    this.username,
  });

  User copyWith({String id, String username}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }
}
