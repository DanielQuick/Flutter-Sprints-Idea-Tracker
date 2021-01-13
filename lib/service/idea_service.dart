import '../model/idea.dart';

class IdeaService {
  //final ideaRef = FirebaseFirestore.instance.collection("ideas");
  Idea _idea;

  Map toMap(Idea idea) {
    var _map = Map<String, dynamic>();
    _map["id"] = idea.id;
    _map["title"] = idea.title;
    _map["description"] = idea.description;
    _map["createdAt"] = idea.createdAt;
    _map["updatedAt"] = idea.updatedAt;
    _map["votes"] = idea.votes;
    return _map;
  }

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

  setCurrentIdea(Idea idea) async{
    await Future.delayed(Duration(seconds: 1));
    this._idea = idea;
  }

  Future<Idea> getCurrentIdea() async {
    await Future.delayed(Duration(seconds: 1));
    return _idea;
  }

}