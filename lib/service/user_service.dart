import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/user.dart';

class UserService{
  ///create variable instances for use
  final userRef = FirebaseFirestore.instance.collection("users");
  static User _user = new User();

  ///existing user for testing
  ///_authenticationService.signIn("foobar@test.com", "123qweASD#\$%");
  final User _testUser = User(
      id: "ZIE1S79L3CRPNn3EaR0yi3sWMOO2",
      email: "foobar@test.com",
      userName: "foobar@test.com",
      photoURL: "_");


  ///method to put the user into the database properly
  toJson(String id) {
    return {
      "id": id,
      "email": _user.email,
      "userName": _user.userName ?? _user.email,
      "photoURL": _user.photoURL ?? "_",

    };
  }

  ///returns the current user string
  String userToString() {
    return 'UserService _user:  id: ${_user.id ?? 'null'}, '
        'email: ${_user.email ?? 'null'}, '
        'userName: ${_user.email ?? 'null'}, '
        'photoURL: ${_user.photoURL ?? 'null'}';
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
  Future<void> removeFromDB(String userId) async {
    await userRef.doc().delete();
    debugPrint('User $userId removed from DB');
  }

  ///to update the user name in the database
  Future<void> updateUserName(String userName) async {
    print("updateUserName(String userName): ${_user.id} / $userName");
    await userRef.doc(_user.id).update({'userName': userName});
    _user = _user.copyWith(userName: userName);
    debugPrint('User ${_user.id} updated DB');
  }

  ///used to update a photoURL if someone wants to include a picture with their
  ///user profile
  Future<void> updateUserPhotoURL(String photoURL) async {
    await userRef.doc(_user.id).update({'photoURL': photoURL});
    _user = _user.copyWith(photoURL: photoURL);
    debugPrint('User ${_user.id} updated PhotoUrl DB');
  }

  ///used to get the document to show user attributes within the database
  ///
  ///gets current logged in user from the database and stores it to _user.
  ///create user in database this is performed within authentication service
  Future<DocumentSnapshot> getCurrentUserDocument() async {
    print('1.  getCurrentUserDocument() at start of method: ' + _user.id);
    DocumentSnapshot doc = await userRef.doc(_user.id).get();
      if (doc.exists) {
        print('2.  getCurrentUserDocument() after if(document.exists): ${_user.id}');
        print('Document data: ${doc.data().entries}');
        await setCurrentUser(
          User(id: _user.id,
          email: doc["email"],
          userName: doc["userName"],
          photoURL: doc["photoURL"],)
        );
        ///setCurrentUser(user);
        print('3.  getCurrentUserDocument() after setCurrentUser(user): ' +
            _user.id);
        print(userToString());
      } else {
        print('Document does not exist on the database.  Loading to database...');
        await userRef.doc(_user.id).set(toJson(_user.id));
        print ('reload currentUserDocument()...');
        await getCurrentUserDocument();
      }
    print('4.  getCurrentUserDocument() at end of method: ' + _user.id);
    print(
        "if 1 - 4 show same user id, setCurrentUser() success from this method.");
    print('Document data: ${doc.data().entries}');
    return doc;
  }

  ///Used to get the user as a stream
  Future<Stream> getCurrentUserAsStream() async {
    return userRef.doc(_user.id).get().asStream();
  }

  runUserServiceTest() async {

    print(
        'start of runUserServiceTest after authentication with _testUser credentials.  '
            'Why is ${_user.id} showing '+userToString());
    print('loading same test user from auth, within service user class');
    //await setCurrentUser(_testUser);
    print('working after setCurrentUser within class...');
    print(userToString());
    await getCurrentUserDocument();
    await updateUserName("Foo Bar Bar Bar");
    await new Future.delayed(const Duration(seconds: 3));
    await updateUserPhotoURL('new images of myself');
    await new Future.delayed(const Duration(seconds: 3));
    await getCurrentUser();
    print(userToString());
    await new Future.delayed(const Duration(seconds: 3));
    var userStream = await getCurrentUserAsStream();
    await new Future.delayed(const Duration(seconds: 3));
    print('getCurrentUserAsStream(): ${userStream.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
    await getCurrentUserDocument();
  }
}
