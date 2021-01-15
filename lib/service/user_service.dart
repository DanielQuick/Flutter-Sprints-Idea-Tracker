import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/user.dart';

class UserService{
  ///create variable instances for use
  final userRef = FirebaseFirestore.instance.collection("users");
  User _user;

  User fromMap(Map<String, dynamic> map){
    return User(
        id: map['id'],
        email : map['email'],
        userName: map['userName'],
        photoURL: map['photoURL'],
    );
  }

  toJson(String id){
    return {
      "id": id,
      "email": _user.email,
      "userName": _user.userName ?? _user.email,
      "photoURL": _user.photoURL ?? "_",
    };
  }

  setCurrentUser(User user) async{
    this._user = user;
    debugPrint('Current user: ${_user.id}');
  }

  Future<User> getCurrentUser() async {
    return _user;
  }

  Future<void> addToDB() async {
    await userRef.doc(_user.id).set(toJson(_user.id));
    debugPrint('User ${_user.id} Added to DB');
  }

  Future<void> removeFromDB() async {
    await userRef.doc(_user.id).delete();
    debugPrint('User ${_user.id} removed from DB');
  }

  Future<void> updateUserName(String userName) async {
    await userRef.doc(_user.id).update({'userName': userName});
    debugPrint('User ${_user.id} updated DB');
  }

  Future<void> updateUserPhotoURL(String photoURL) async {
    await userRef.doc(_user.id).update({'photoURL': photoURL});
    debugPrint('User ${_user.id} updated PhotoUrl DB');
  }


  Future<DocumentSnapshot> getCurrentUserDocument()async{
    DocumentSnapshot doc =  await userRef.doc(_user.id).get();
    debugPrint('Document Snapshot ID: ${doc.id}');
    return doc;
  }

  Future<Stream> getCurrentUserAsStream() async {
    return userRef.doc(_user.id).get().asStream();
  }

  Future<void> getUserFromDB() async {
    DocumentSnapshot doc = await userRef.doc(_user.id).get();
    ///if user document does not exist, create user in database from authentication service
    if (doc.data() != null){
      return doc;
    } else {
      addToDB();
      doc = await userRef.doc(_user.id).get();
    }
    return doc;
  }

  runUserServiceTest() {

  }

}