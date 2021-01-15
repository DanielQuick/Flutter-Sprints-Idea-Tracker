import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/sprint.dart';

class SprintService {
  ///create variable instances for use
  final sprintRef = FirebaseFirestore.instance.collection("ideas");
  Sprint _sprint;

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
      potentialLeaders: map['potentialLeaders'],
      posts: map['posts'],
    );
  }

  toJson(String id) {
    return {
      'id': _sprint.id ?? id,
      "title": _sprint.title,
      "titleArray": _sprint.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": _sprint.description,
      "createdAt": DateTime.now().microsecondsSinceEpoch,
      "updatedAt": _sprint.updatedAt,
      "potentialLeaders": new List<String>(),
      "members": new List<String>(),
      "posts": new List<SprintPost>(),
    };
  }

  sprintToString(){
    print(
        'Idea: id: ${_sprint.id}, '
            'title: ${_sprint.title}, '
            'description: ${_sprint.description}, '
            'createdAt: ${_sprint.createdAt}, '
            'updatedAt: ${_sprint.updatedAt}, '
            'members: ${_sprint.members}, '
            'potentialLeaders: ${_sprint.potentialLeaders}, '
            'posts: ${_sprint.posts}');  }

  getUpdatedAt() {
    return DateTime
        .now()
        .microsecondsSinceEpoch;
  }

  Future setCurrentSprint(Sprint sprint) async {
    this._sprint = sprint;
    debugPrint('Added ${sprint.id} as current sprint');
  }

  Future<Sprint> getCurrentSprint() async {
    return _sprint;
  }

  Future<void> addToDB() async {
    DocumentReference docReference = sprintRef.doc();
    await sprintRef.doc().set(toJson(docReference.id));
    debugPrint('Added sprint id: ${_sprint.id} to DB');
  }

  Future<void> removeFromDB() async {
    await sprintRef.doc(_sprint.id).delete();
    debugPrint('removed Sprint ${_sprint.id} from DB');
  }

  Future<void> updateTitle(String title) async {
    await sprintRef.doc(_sprint.id).update({'title': title});
    debugPrint('updated sprint ${_sprint.id } title in DB');
  }

  Future<void> updateDescription(String description) async {
    await sprintRef.doc(_sprint.id).update({'description': description});
    debugPrint('updated description DB');
  }

  Future<void> updateUpdatedAt() async {
    await sprintRef.doc(_sprint.id).update({'updatedAt': getUpdatedAt()});
    _sprint = _sprint.copyWith(updatedAt: getUpdatedAt());
    debugPrint('updated updatedAt DB');
  }

  Future<void> updateTeamLeader(String teamLeader) async {
    await sprintRef.doc(_sprint.id).update({'teamLeader': teamLeader});
    _sprint = _sprint.copyWith(teamLeader: teamLeader);
    debugPrint('updated teamLeader DB');
  }

  Future<void> updatePotentialLeaders(String potentialLeaders) async{
    sprintRef.doc(_sprint.id).update({
      "potentialLeaders": FieldValue.arrayUnion(['$potentialLeaders'])
    }).then((_) {
      debugPrint('Added potentialLeaders: $potentialLeaders to sprint ${_sprint.id}');
    });
    debugPrint('Added potentialLeaders: $potentialLeaders to sprint ${_sprint.id}');
  }

  Future<void> updateMembers(String member) async{
    sprintRef.doc(_sprint.id).update({
             "member": FieldValue.arrayUnion(['$member'])
           }).then((_) {
             debugPrint('Added member: $member to sprint ${_sprint.id}');
           });
    debugPrint('Added member: $member to sprint ${_sprint.id}');
  }

  Future<void> updatePosts(SprintPost post) async{
    sprintRef.doc(_sprint.id).update({
             "post": FieldValue.arrayUnion(['post'])
           }).then((_) {
             debugPrint('Added post: $post to sprint ${_sprint.id}');
           });
    debugPrint('Added post: $post to sprint ${_sprint.id}');
  }

  runSprintServicesTest(){

  }
}