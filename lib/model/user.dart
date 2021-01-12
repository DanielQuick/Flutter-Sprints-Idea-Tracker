import 'package:flutter/cupertino.dart';

class User {
  String id;
  String email;
  String displayName;
  String photoURL;

  User({
    this.id,
    this.email,
    this.displayName,
    this.photoURL,
  });

  User copyWith({@required String id, @required String email, String displayName, String photoURL}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? "_",
    );
  }
}
