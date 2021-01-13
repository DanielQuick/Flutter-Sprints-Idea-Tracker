import 'package:flutter/cupertino.dart';
import '../model/user.dart';

class UserService{
  ///create variable instances for use
  //final userRef = FirebaseFirestore.instance.collection("users");
  User _user;

  Map toMap(User user) {
    var _map = Map<String, dynamic>();
    _map["uid"] = user.id;
    _map["email"] = user.email;
    _map["userName"] = user.userName ?? user.email;
    _map["photoURL"] = user.photoURL ?? '_';
    return _map;
  }

   User fromMap(Map<String, dynamic> map){
    return User(
        id: map['id'],
        email : map['name'],
        userName: map['userName'],
        photoURL: map['photoURL']
    );
  }

  setCurrentUser(User user) async{
    this._user = user;
  }

  Future<User> getCurrentUser() async {
    return _user;
  }

  Future<void> addToDB() async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(user.id).set(toMap(user));
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