import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/user.dart';

class UserService {
  ///create variable instances for use
  CollectionReference _userRef;
  User _user;

  ///this initializes the collection reference
  initialize() {
    _userRef = FirebaseFirestore.instance.collection("users");
  }

  ///method to put the user into the database properly
  _toJson(User _user) {
    return {
      "id": _user.id,
      "email": _user.email,
      "userName": _user.userName ?? _user.email,
      "photoURL": _user.photoURL ?? "_",
    };
  }

  ///Method to convert Firestore DocumentSnapshot to a User Object
  User _fromFirestore(DocumentSnapshot doc) {
    User user = new User(
        id: doc.id ?? 'null',
        email: doc.data()['email'] ?? 'null',
        userName: doc.data()['userName'] ?? 'null',
        photoURL: doc.data()['photoURL'] ?? 'null');
    return user;
  }

  ///Current user is always the user that is logged in
  ///this is performed within authentication service upon sign up/in
  setUser(User user) {
    _user = user;
    debugPrint('setCurrentUser(User user): ${_user.id}');
  }

  ///Returns the latest getUserDocument() user object
  getUser() {
    return _user;
  }

  ///This method can be used to remove the current user from the database.
  ///This method should be used with caution,
  ///if you remove yourself you can be added back if you log back in
  Future<void> delete(User user) async {
    await _userRef.doc(user.id).delete();
    debugPrint('User ${user.id} removed from DB');
  }

  ///to replace entire user in database ...Be careful
  Future<void> add(User user) async {
    print('replace user ${user.id}');
    return await _userRef.doc(user.id).set(_toJson(user));
  }

  ///to update the user name in the database
  Future<void> updateUserName(User user) async {
    print("updateUserName(String userName): ${user.id} / ${user.userName}");
    await _userRef.doc(user.id).update({'userName': user.userName});
    debugPrint('User ${user.id} updated userName: ${user.userName} DB');
  }

  ///used to update a photoURL if someone wants to include a picture with their
  ///user profile
  Future<void> updateUserPhotoURL(User user) async {
    await _userRef.doc(user.id).update({'photoURL': user.photoURL});
    debugPrint('User ${user.id} updated PhotoUrl DB');
  }

  ///used to get the document to show user attributes within the database
  ///
  ///gets current logged in user from the database and stores it to _user.
  ///create user in database this is performed within authentication service
  Future<DocumentSnapshot> setUserFromFirestore(User user) async {
    DocumentSnapshot snapshot = await _userRef.doc(user.id).get();
    User userFromDocument;
      if (snapshot.exists) {
        userFromDocument = _fromFirestore(snapshot);
        setUser(userFromDocument);
        print('Found User: ${snapshot.data()['id']}');
      } else {
        print('Document does not exist on the database.  Loading to database...');
        await add(user);
        print ('reload getUserDocument()...');
        setUserFromFirestore(user);
      }
      print(snapshot.data());
    return snapshot;
  }

  ///Used to get the user as a stream
  Future<Stream> getCurrentUserAsStream(User user) async {
    return _userRef.doc(user.id).get().asStream();
  }
}
