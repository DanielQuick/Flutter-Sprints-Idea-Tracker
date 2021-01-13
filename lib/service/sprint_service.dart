import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../model/sprint.dart';

class SprintService {
  //final ideaRef = FirebaseFirestore.instance.collection("ideas");
  Sprint _sprint;

  /*
  final String id;
  final String title;
  final String description;
  final int createdAt;
  final int updatedAt;
  final String teamLeader;
  final List<String> members;
  final List<String> potentialLeaders;
  List<SprintPost> posts;
   */

  Map toMap(Sprint sprint) {
    var _map = Map<String, dynamic>();
    _map["id"] = sprint.id;
    _map["title"] = sprint.title;
    _map["description"] = sprint.description;
    _map["createdAt"] = sprint.createdAt;
    _map["updatedAt"] = sprint.updatedAt;
    _map["members"] = sprint.members;
    _map["potentialLeaders"] = sprint.potentialLeaders;
    _map["posts"] = sprint.posts;
    return _map;
  }

  Sprint fromMap(Map<String, dynamic> map){
    return Sprint(
      id: map['id'],
      title : map['title'],
      description: map['description'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      members: map['members'],
      posts: map['posts'],
    );
  }

  Future setCurrentIdea(Sprint sprint) async{
    await Future.delayed(Duration(seconds: 1));
    this._sprint = sprint;
    debugPrint('Added $sprint as current sprint');
  }

  Future<Sprint> getCurrentIdea() async {
    await Future.delayed(Duration(seconds: 1));
    return _sprint;
  }

  Future<void> addToDB() async {
    await Future.delayed(Duration(seconds: 1));
    //await ideaRef.doc().set(toMap(_sprint));
    debugPrint('Added sprint id: ${_sprint.id} to DB');
  }

  Future<void> removeFromDB() async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(_sprint.id).delete();
    debugPrint('removed Sprint from DB');
  }

  Future<void> updateUserName(String userName) async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(_sprint.id).update({'userName': userName});
    debugPrint('updated DB');
  }

  Future<void> updateUserPhotoURL(String photoURL) async {
    await Future.delayed(Duration(seconds: 1));
    //await userRef.doc(user.id).update({'photoURL': photoURL});
    debugPrint('updated DB');
  }
}