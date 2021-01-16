import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:idea_tracker/service/authentication_service.dart';
import '../model/user.dart';

class UserService {
  ///create variable instances for use
  final userRef = FirebaseFirestore.instance.collection("users");
  User _user;
  final User _testUser = User(
      id: "ZIE1S79L3CRPNn3EaR0yi3sWMOO2",
      email: "foobar@test.com",
      userName: "foobar@test.com",
      photoURL: "_");
  AuthenticationService _authenticationService;

  User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      userName: map['userName'],
      photoURL: map['photoURL'],
    );
  }

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
    return 'UserService _user:  id: ${_user.id}, '
        'email: ${_user.email}, '
        'userName: ${_user.email}, '
        'photoURL: ${_user.photoURL}';
  }

  ///Current user is always the user that is logged in
  ///this is performed within authentication service upon sign up/in
  setCurrentUser(User user) async {
    this._user = user;
    debugPrint('setCurrentUser(User user): ${_user.id}');
  }

  ///Returns the current user object
  Future<User> getCurrentUser() async {
    return _user;
  }

  ///adds the current user to the database
  Future<void> addToDB() async {
    await userRef.doc(_user.id).set(toJson(_user.id));
    debugPrint('User ${_user.id} Added to DB');
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
    DocumentSnapshot doc;
    await userRef.doc(_user.id).get().then((document) {
      print('2.  getCurrentUserDocument() before if(document.exists): ' +
          _user.id);
      if (document.exists) {
        doc = document;
        _user = _user.copyWith(
          id: _user.id,
          email: document["email"],
          userName: document["userName"],
          photoURL: document["photoURL"],
        );
        ///setCurrentUser(user);
        print('3.  getCurrentUserDocument() after setCurrentUser(user): ' +
            _user.id);
        print(userToString());
      } else {
        print('Document does not exist on the database.  Loading to database.');
        addToDB();
        getCurrentUserDocument();
      }
    });
    print('4.  getCurrentUserDocument() at end of method: ' + _user.id);
    print(
        "if 1 - 4 show same user id, setCurrentUser() success from this method.");
    print('Document data: ${doc.data()}');
    return doc;
  }

  ///Used to get the user as a stream
  Future<Stream> getCurrentUserAsStream() async {
    return userRef.doc(_user.id).get().asStream();
  }

  runUserServiceTest() async {
    print(
        'start of runUserServiceTest after authentication.  Why is _user.id showing '+userToString());
    /*await updateUserName("Foo Bar");
    await new Future.delayed(const Duration(seconds: 3));
    await updateUserPhotoURL(
        'https://www.nasa.gov/sites/default/files/styles/image_card_4x3_ratio/public/images/440676main_STScI-2007-04a-full_full.jpg');
    await new Future.delayed(const Duration(seconds: 3));

    await getCurrentUser();
    print(userToString());
    await new Future.delayed(const Duration(seconds: 3));
    var userStream = await getCurrentUserAsStream();
    await new Future.delayed(const Duration(seconds: 3));
    print('getCurrentUserAsStream(): ${userStream.toString()}');
    var userStream0 = await getCurrentUserDocument();
    print('getCurrentUserAsStream(): ${userStream0.toString()}');

     */
  }
}
