import 'package:flutter/cupertino.dart';

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

  User copyWith({@required String id, String email, String userName, String photoURL}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      photoURL: photoURL ?? "_",
    );
  }
}
