import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/user.dart';

class UserService{
  ///create variable instances for use
  final userRef = FirebaseFirestore.instance.collection("users");
  static User _user;

  ///method to put the user into the database properly
  toJson(User _user) {
    return {
      "id": _user.id,
      "email": _user.email,
      "userName": _user.userName ?? _user.email,
      "photoURL": _user.photoURL ?? "_",

    };
  }

  ///Current user is always the user that is logged in
  ///this is performed within authentication service upon sign up/in
  setCurrentUser(User user) async {
    _user = user;
    debugPrint('setCurrentUser(User user): ${_user.id}');
  }

  ///Returns the current user object
  Future<User> getCurrentUser() async {
    return _user;
  }

  ///This method can be used to remove the current user from the database.
  ///This method should be used with caution,
  ///if you remove yourself you can be added back if you log back in
  Future<void> delete(User user) async {
    await userRef.doc(user.id).delete();
    debugPrint('User ${user.id} removed from DB');
  }

  ///to replace entire user in database ...Be careful
  Future<void> add(User user) async{
    print('replace user ${user.id}');
    return await userRef.doc(user.id).set(toJson(user));
  }

  ///to update the user name in the database
  Future<void> updateUserName(User user) async {
    print("updateUserName(String userName): ${user.id} / ${user.userName}");
    await userRef.doc(user.id).update({'userName': user.userName});
    debugPrint('User ${user.id} updated userName: ${user.userName} DB');
  }

  ///used to update a photoURL if someone wants to include a picture with their
  ///user profile
  Future<void> updateUserPhotoURL(User user) async {
    await userRef.doc(user.id).update({'photoURL': user.photoURL});
    debugPrint('User ${user.id} updated PhotoUrl DB');
  }

  ///used to get the document to show user attributes within the database
  ///
  ///gets current logged in user from the database and stores it to _user.
  ///create user in database this is performed within authentication service
  Future<DocumentSnapshot> getCurrentUserDocument(User user) async {
    DocumentSnapshot doc = await userRef.doc(user.id).get();
      if (doc.exists) {
        print(user.toString());
        print('Document data: ${doc.data().entries}');
      } else {
        print('Document does not exist on the database.  Loading to database...');
        await add(user);
        print ('reload currentUserDocument()...');
        await getCurrentUserDocument(user);
      }
    return doc;
  }

  ///Used to get the user as a stream
  Future<Stream> getCurrentUserAsStream(User user) async {
    return userRef.doc(user.id).get().asStream();
  }

}
