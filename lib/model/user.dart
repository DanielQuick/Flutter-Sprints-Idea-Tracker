class User {
  String id;
  String email;
  String userName;
  String photoURL;

  User({
    this.id,
    this.email,
    this.userName,
    this.photoURL,
  });

  User copyWith({String id, String email, String userName, String photoURL}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      photoURL: photoURL ?? this.photoURL ?? '_',
    );
  }

  @override
  ///returns the user string
  toString() {
    return 'User:  id: ${this.id ?? 'null'}, '
        'email: ${this.email ?? 'null'}, '
        'userName: ${this.userName ?? 'null'}, '
        'photoURL: ${this.photoURL ?? 'null'}';
  }
}
