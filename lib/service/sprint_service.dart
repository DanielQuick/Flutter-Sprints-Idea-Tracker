import 'package:flutter/cupertino.dart';
import 'package:idea_tracker/service/services.dart';
import '../model/sprint.dart';

class SprintService {
  ///create variable instances for use
  //final sprintRef = FirebaseFirestore.instance.collection("ideas");
  Sprint _sprint;
  UserService _userService = new UserService();

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

  Sprint fromMap(Map<String, dynamic> map) {
    return Sprint(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      members: map['members'],
      posts: map['posts'],
    );
  }

  toJson(String id) {
    return {
      'id': _sprint.id ?? id,
      "title": _sprint.title,
      "titleArray": _sprint.title.toLowerCase()
          .split(new RegExp('\\s+'))
          .toList(),
      "description": _sprint.description,
      "createdAt": DateTime
          .now()
          .microsecondsSinceEpoch,
      "updatedAt": _sprint.updatedAt,
      "members": new List<String>(),
      "posts": new List<String>(),
    };
  }

  toString(){

  }

  getUpdatedAt() {
    return DateTime
        .now()
        .microsecondsSinceEpoch;
  }

  Future setCurrentIdea(Sprint sprint) async {
    await Future.delayed(Duration(seconds: 1));
    this._sprint = sprint;
    debugPrint('Added $sprint as current sprint');
  }

  Future<Sprint> getCurrentIdea() async {
    await Future.delayed(Duration(seconds: 1));
    return _sprint;
  }

  Future<void> addToDB() async {
    Future.delayed(Duration(seconds: 1));
    //DocumentReference docReference = sprintRef.doc();
    //await sprintRef.doc().set(toJson(docReference.id));
    debugPrint('Added sprint id: ${_sprint.id} to DB');
  }

  Future<void> removeFromDB() async {
    await Future.delayed(Duration(seconds: 1));
    //await sprintRef.doc(_sprint.id).delete();
    debugPrint('removed Sprint from DB');
  }

  Future<void> updateTitle(String title) async {
    await Future.delayed(Duration(seconds: 1));
    //await sprintRef.doc(_sprint.id).update({'title': title});
    debugPrint('updated title DB');
  }

  Future<void> updateDescription(String description) async {
    await Future.delayed(Duration(seconds: 1));
    //await sprintRef.doc(_sprint.id).update({'description': description});
    debugPrint('updated description DB');
  }

  Future<void> updateUpdatedAt() async {
    await Future.delayed(Duration(seconds: 1));
    //await sprintRef.doc(_sprint.id).update({'updatedAt': getUpdatedAt()});
    debugPrint('updated updatedAt DB');
  }

  Future<void> updateTeamLeader(String teamLeader) async {
    await Future.delayed(Duration(seconds: 1));
    //await ideaRef.doc(_sprint.id).update({'teamLeader': teamLeader});
    debugPrint('updated teamLeader DB');
  }

  Future<void> updateMembers(String member) async{
    await Future.delayed(Duration(seconds: 1));
    //sprintRef.doc(_sprint.id).update({
    //         "member": FieldValue.arrayUnion(['$member'])
    //       }).then((_) {
    //         debugPrint('Added member: $member to sprint ${_sprint.id}');
    //       });
    debugPrint('Added member: $member to sprint ${_sprint.id}');
  }

  Future<void> updatePosts(String post) async{
    await Future.delayed(Duration(seconds: 1));
    //sprintRef.doc(_sprint.id).update({
    //         "member": FieldValue.arrayUnion(['post'])
    //       }).then((_) {
    //         debugPrint('Added post: $post to sprint ${_sprint.id}');
    //       });
    debugPrint('Added post: $post to sprint ${_sprint.id}');
  }
}