import 'package:flutter/cupertino.dart';

import '../model/idea.dart';

class IdeaService {
  ///create variable instances for use
  //final ideaRef = FirebaseFirestore.instance.collection("ideas");
  Idea _idea;

  Idea fromMap(Map<String, dynamic> map){
    return Idea(
        id: map['id'],
        title : map['title'],
        description: map['description'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
        votes: map['votes'],
    );
  }

  toJson(String id) {
    return {
      "id": id,
      "title": _idea.title,
      "titleArray": _idea.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": _idea.description,
      "createdAt": DateTime.now().microsecondsSinceEpoch,
      "updatedAt": _idea.updatedAt,
      "votes": new List<String>(),
    };
  }

  getUpdatedAt(){
    return DateTime.now().microsecondsSinceEpoch;
  }

  setCurrentIdea(Idea idea) async{
    await Future.delayed(Duration(seconds: 1));
    this._idea = idea;
  }

  Future<Idea> getCurrentIdea() async {
    await Future.delayed(Duration(seconds: 1));
    return _idea;
  }

  Future<void> addToDB() async {
    Future.delayed(Duration(seconds: 1));
    //DocumentReference docReference = ideaRef.doc();
    //await ideaRef.doc().set(toJson(docReference.id));
    debugPrint('Added idea id: ${_idea.id} to DB');
  }

  Future<void> updatePosts(String vote) async{
    //ideaRef.doc(_sprint.id).update({
    //         "member": FieldValue.arrayUnion(['vote'])
    //       }).then((_) {
    //         debugPrint('Added vote: $vote to idea ${_idea.id}');
    //       });
    debugPrint('Added vote: $vote to idea ${_idea.id}');
  }

}