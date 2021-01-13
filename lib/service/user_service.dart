import 'package:flutter/cupertino.dart';
import '../model/user.dart';

class UserService{
  ///create variable instances for use
  //final userRef = FirebaseFirestore.instance.collection("users");
  User _user;

  User fromMap(Map<String, dynamic> map){
    return User(
        id: map['id'],
        email : map['email'],
        userName: map['userName'],
        photoURL: map['photoURL'],
    );
  }

  toJson(){
    return {
      "id": _user.id,
      "email": _user.email,
      "userName": _user.userName ?? _user.email,
      "photoURL": _user.photoURL ?? "_",
    };
  }

  setCurrentUser(User user) async{
    this._user = user;
  }

  Future<User> getCurrentUser() async {
    return _user;
  }

  Future<void> addToDB() async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(user.id).set(toJson(_user));
    debugPrint('${_user.id} Added to DB');
  }

  Future<void> removeFromDB() async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(user.id).delete();
    debugPrint('${_user.id} removed from DB');
  }

  Future<void> updateUserName(String userName) async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(user.id).update({'userName': userName});
    debugPrint('${_user.id} updated DB');
  }

  Future<void> updateUserPhotoURL(String photoURL) async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(user.id).update({'photoURL': photoURL});
    debugPrint('${_user.id} updated PhotoUrl DB');
  }

  /*
  Future<DocumentSnapshot> getCurrentUserDocument()async{
    await Future.delayed(Duration(seconds: 1));
    return toMap(user);
    //return await userRef.doc(user.id).get();
  }

  Future<Stream> getCurrentUserAsStream() async {
    return userRef.doc(user.id).get().asStream();
  }

  Future<void> getUserFromDB() async {
    final DocumentSnapshot doc = await userRef.doc(user.id).get();
    ///if user document does not exist, create user in database from authentication service
    if (doc.data() != null){
      return doc;
    } else {
      addToDB();
      getUserFromDB();
    }
    return null;
  }
*/

}