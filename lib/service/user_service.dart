import '../model/user.dart';

class UserService{
  ///create variable instances for use
  //final userRef = Firestore.instance.collection("users");

  Map toMap(User user) {
    var _map = Map<String, dynamic>();
    _map["uid"] = user.id;
    _map["userName"] = user.email;
    _map["displayName"] = user.displayName;
    return _map;
  }

   User fromMap(Map<String, dynamic> map){
    return User(
        id: map['id'],
        email : map['name'],
        displayName: map['displayName']
    );
  }

/*
  Future<void> addToDB(User user) async {
    await userRef.document(user.id).setData(toMap(user));
  }

  Future<void> removeFromDB(User user) async {
    await userRef.document(user.id).delete();
  }
  
  Future<void> updateDB(User user) async {
    await userRef.document(user.id).update(toMap(user));
  }

  Future<User> getUserFromDB({String uid}) async {
    final DocumentSnapshot doc = await userRef.document(uid).get();
    return fromMap(doc.data());
  }
 */

}