import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:idea_tracker/model/user.dart';

enum UpdateUser { userName, photo }

class UserService {
  ///create variable instances for use
  CollectionReference _userRef;

  ///this initializes the collection reference
  initialize() {
    _userRef = FirebaseFirestore.instance.collection("users");
  }

  /// Returns the requested User Object from Firestore if the user is not found
  /// Returns null
  Future<User> get(String id) async {
    User user;
    await _userRef.doc(id).get().then((snapshot) {
      if (snapshot.exists) {
        user = _fromFirestore(snapshot);
      } else {
        user = null;
      }
    }).catchError((error) => debugPrint("Failed to get user: $error"));
    return user;
  }

  /// Central update command to update user objects.  Uses Enum UpdateUser for
  /// the switch() case :  Returns the updated user object as Future
  /// Use case Example: update(user, UpdateUser.photo, "https://urlToPhoto.jpg");
  Future<User> update(User user, UpdateUser update, String updateString) async {
    User updatedUser = user;
    switch (update) {
      case UpdateUser.userName:
        {
          updatedUser = await _updateUserName(user, updateString);
          return updatedUser;
        }
        break;
      case UpdateUser.photo:
        {
          updatedUser = await _updateUserPhotoURL(user, updateString);
          return updatedUser;
        }
        break;
      default:
        {
          print(
              "Nothing was updated, please use Enum UpdateUser to update your User ${user.id}.");
          return user;
        }
        break;
    }
  }

  ///This function can be used to remove the current user from the database.
  ///This function should be used with caution,
  ///if you remove yourself you can be added back when you log out and then
  /// back in
  Future<void> delete(User user) async {
    await _userRef.doc(user.id).delete().then((_) {
      debugPrint('User ${user.id} removed from DB');
    }).catchError((error) => debugPrint("Failed to delete user: $error"));
  }

  ///Below function is for use within authentication services

  ///used to get the document to show user attributes within the database
  ///
  ///user parameter stores the User object to _user.
  ///this creates user in database if the user doesn't exist yet
  ///if the document is found within the User is stored
  ///
  /// Returns a DocumentSnapshot of the user.
  Future<DocumentSnapshot> setAuthenticatedUserFromFirestore(User user) async {
    DocumentSnapshot snapshot =
        await _userRef.doc(user.id).get().then((document) async {
      if (document.exists) {
        _fromFirestore(document);
        print('Found User: ${document.data()['id']}');
        return document;
      } else {
        print(
            'Document does not exist on the database.  Loading to database...');
        await _add(user);
        print('reload getUserDocument()...');
        setAuthenticatedUserFromFirestore(user);
        return null;
      }
    }).catchError((error) => debugPrint("Failed to get user document: $error"));
    ;
    return snapshot;
  }

  ///Below methods are for internal use only

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
        id: doc.id,
        email: doc.data()['email'] ?? 'null',
        userName: doc.data()['userName'] ?? 'null',
        photoURL: doc.data()['photoURL'] ?? 'null');
    return user;
  }

  ///adds user to the database
  ///can be used to replace entire user in database ...Be careful
  ///Returns updated user
  Future<void> _add(User user) async {
    return await _userRef.doc(user.id).set(_toJson(user)).then((_) {
      debugPrint('User ${user.id} added to DB');
    }).catchError((error) => debugPrint("Failed to add user: $error"));
  }

  ///to update the user name in the database
  ///Returns updated user
  Future<User> _updateUserName(User user, String newUserName) async {
    print("updateUserName(String userName): ${user.id} / ${user.userName}");
    return await _userRef
        .doc(user.id)
        .update({'userName': newUserName}).then((_) {
      debugPrint(
          'User ${user.id} updated userName: ${user.userName} to $newUserName DB');
      return get(user.id);
    }).catchError((error) => debugPrint("Failed to update userName: $error"));
  }

  ///used to update a photoURL if someone wants to include a picture with their
  ///user profile
  ///Returns updated user
  Future<User> _updateUserPhotoURL(User user, String updatePhotoURL) async {
    return await _userRef
        .doc(user.id)
        .update({'photoURL': updatePhotoURL}).then((_) {
      debugPrint('User ${user.id} updated PhotoUrl DB');
      return get(user.id);
    }).catchError(
            (error) => debugPrint("Failed to update user photoURL: $error"));
  }

  ///Below method for future use

  ///Used to get the user as a stream
  Stream getCurrentUserAsStream(User user) {
    return _userRef.doc(user.id).get().asStream();
  }
}
