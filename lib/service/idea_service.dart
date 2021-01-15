import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/idea.dart';

///for this service class, users of this class do not have to worry about the updatedAt
///or created at variables within the Idea object

class IdeaService {
  ///create variable instances for use
  final ideaRef = FirebaseFirestore.instance.collection("ideas");
  ///This is the current stored Idea that most all functions within this class will depend on
  ///Make sure to set this idea for updates it is important to note that creation of an
  ///Idea only needs title and description
  Idea _idea;
  ///This is the Idea used for testing with minimal input for operation within firestore
  Idea _testIdea = new Idea(
    id: 'CkJU9vHJ0lNquT7XIZKG',
    description: 'Test description',
    title: 'Test title',
  );

  ///used to input the idea into the database.
  ///This is only used the first time an idea is input into the database
  toJson(String id) {
    return {
      "id": id,
      "title": _idea.title,
      "titleArray": _idea.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": _idea.description,
      "createdAt": _idea.createdAt ?? DateTime.now().microsecondsSinceEpoch,
      "updatedAt": _idea.updatedAt ?? DateTime.now().microsecondsSinceEpoch,
      "votes": _idea.votes ?? new List<String>(),
    };
  }

  /// print the current stored idea to a string for debugging purposes
  ideaToString() {
    print(
        'Idea: id: ${_idea.id}, '
            'title: ${_idea.title}, '
            'description: ${_idea.description}, '
            'createdAt: ${_idea.createdAt}, '
            'updatedAt: ${_idea.updatedAt}, '
            'votes: ${_idea.votes}');
  }

  /// stores an Idea into _idea
  setCurrentIdea(Idea idea) async {
    this._idea = idea;
    debugPrint("setCurrentIdea()) ${_idea.title}");
  }

  /// returns an the Idea stored into _idea
  Future<Idea> getCurrentIdea() async {
    debugPrint("getCurrentIdea()) ${_idea.title}");
    return _idea;
  }

  /// adds the _idea to the database
  Future<void> addToDB() async {
    DocumentReference docReference = ideaRef.doc();
    await ideaRef.doc(docReference.id).set(toJson(docReference.id));
    _idea = _idea.copyWith(id: docReference.id, createdAt: DateTime.now().microsecondsSinceEpoch);
    debugPrint('Added idea id: ${_idea.id} to DB');
  }

  /// removes _idea from the database
  Future<void> removeFromDB() async {
    await ideaRef.doc(_idea.id).delete();
    _idea = null;
    debugPrint('removed idea ${_idea.id} from DB');
  }

  /// updates _idea title in the database and updates _idea with that title
  Future<void> updateTitle(String title) async {
    await ideaRef.doc(_idea.id).update({'title': title});
    _idea = _idea.copyWith(title: title);
    updateUpdatedAt();
    debugPrint('updated idea ${_idea.id } title in DB');
  }

  /// updates _idea description in the database and updates _idea with that description
  Future<void> updateDescription(String description) async {
    await ideaRef.doc(_idea.id).update({'description': description});
    _idea = _idea.copyWith(description: description);
    updateUpdatedAt();
    debugPrint('updated idea ${_idea.id } description DB');
  }

  /// updates _idea udpatedAt in the database and updates _idea with that update
  Future<void> updateUpdatedAt() async {
    await ideaRef.doc(_idea.id).update({'updatedAt': DateTime.now().microsecondsSinceEpoch});
    _idea = _idea.copyWith(updatedAt: DateTime.now().microsecondsSinceEpoch);
    debugPrint('updated idea ${_idea.id } updatedAt DB');
  }

  /// updates _idea in the database and udpates _idea with that update
  Future<void> updateVotes(String vote) async {
    await ideaRef.doc(_idea.id).update({
      "votes": FieldValue.arrayUnion([vote])
    }).then((_) {
      updateUpdatedAt();
      debugPrint('Added vote: $vote to idea ${_idea.id}');
    });

  }

  /// The idea here is to get a document ID from a Stream of multiple documents
  /// then store it to the current _idea for use of display and updates for Idea Services.
  ///
  /// To get the document ID to pass to this function:
  ///  1. StreamBuilder -> store as AsyncSnapshot<QuerySnapshot> snapshot using
  ///    getAllIdeasFromDBStream(), getIdeasFromDBForCurrentMonthStream(), or searchIdeasByTitle()
  ///  2. ListView -> children: snapshot.data.docs.map((document) widgets for each document)
  ///  3. access a specific idea "onTapped" with this method using "document.id".
  getIdeaFromDBDocument(String documentId) async{
    DocumentSnapshot doc;
    await ideaRef.doc(documentId).get().then((doc) {
      if (doc.exists) {
        print('Document data: ${doc.data()}');
        _idea = _idea.copyWith(id: doc.id,
            title: doc.data()["title"],
            description: doc.data()["description"],
            createdAt: doc.data()["createdAt"],
            updatedAt: doc.data()["updatedAt"],
            votes: doc.data()['categories'] as List<String>);
      } else {
        print('Document does not exist on the database');
      }
    });
    ideaToString();
    return doc;
  }

  ///get _idea as a stream, returns AsyncSnapshot<QuerySnapshot>
  getCurrentIdeaFromDBAsStream() async{
    debugPrint('getCurrentIdeaFromDBStream() performing...');
    return ideaRef.doc(_idea.id).get().asStream();
  }

  ///get all idea documents from database,returns stream of AsyncSnapshot<QuerySnapshot>
  getAllIdeasFromDBStream() async {
    debugPrint('getAllIdeasFromDBStream() performing...');
    return ideaRef.snapshots();
  }

  /// returns all ideas that were created within the last month as stream of AsyncSnapshot<QuerySnapshot>
  getIdeasFromDBForCurrentMonthStream() async {
    debugPrint('getIdeasFromDBForCurrentMonthStream() performing...');
    return ideaRef.where('createdAt', isGreaterThanOrEqualTo: DateTime.now().microsecondsSinceEpoch - 2629743 );
  }

  ///Used to search all ideas by title and returns stream of AsyncSnapshot<QuerySnapshot>
  searchIdeasByTitle(String search){
    debugPrint('searchIdeasByTitle() performing...');
    return ideaRef.where('titleArray', arrayContains: search.toLowerCase()).snapshots();
  }

  ///testing all functions of this service class
  runIdeaServiceTest() async{
    setCurrentIdea(_testIdea);
    getCurrentIdea();
    ideaToString();
    await addToDB();
    await new Future.delayed(const Duration(seconds: 3));
    ideaToString();
    await updateTitle('Updated Title');
    await new Future.delayed(const Duration(seconds: 3));
    ideaToString();
    await updateDescription("Updated Description");
    await new Future.delayed(const Duration(seconds: 3));
    ideaToString();
    await updateVotes("vote yes");
    await new Future.delayed(const Duration(seconds: 3));
    ideaToString();
    await getIdeaFromDBDocument(_testIdea.id);
    await new Future.delayed(const Duration(seconds: 3));
    Stream<DocumentSnapshot> streamedCurrentIdea = await getCurrentIdeaFromDBAsStream();
    await new Future.delayed(const Duration(seconds: 3));
    print('from getCurrentIdeaFromDBAsStream(): ${streamedCurrentIdea.length}');
    List<String> titles;
    var title = await searchIdeasByTitle('TiTle');
    print('from searchIdeasByTitle(): ${title.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
    var title0 = await getIdeasFromDBForCurrentMonthStream();
    print('from getIdeasFromDBForCurrentMonthStream(): ${title0.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
    var title1 = await getAllIdeasFromDBStream();
    print('from getAllIdeasFromDBStream(): ${title1.toString()}');

  }//end test
}
