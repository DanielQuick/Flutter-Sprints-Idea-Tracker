import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/idea.dart';
import 'services.dart';


///for this service class, users of this class do not have to worry about the updatedAt
///or createdAt variables within the Idea object

class IdeaService {
  ///create variable instances for use
  final ideaRef = FirebaseFirestore.instance.collection("ideas");

  ///This is the current stored Idea that most all functions within this class will depend on
  ///Make sure to set this idea for updates it is important to note that creation of an
  ///Idea only needs title and description
  static Idea _idea;

  ///used to input the idea into the database.
  ///This is only used the first time an idea is input into the database
  toJson(Idea idea, String id) {
    return {
      "id": id,
      "title": idea.title,
      "titleArray":
          idea.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": idea.description,
      "createdAt": idea.createdAt ?? currentTimeInSeconds(),
      "updatedAt": idea.updatedAt ?? currentTimeInSeconds(),
      "votes": idea.votes ?? new List<String>(),
    };
  }

  ///Create Idea object from Firestore DocumentSnapshot
  fromFirestore(DocumentSnapshot doc) {
    Idea idea = new Idea(
        id: doc.id,
        title: doc.data()["title"],
        description: doc.data()["description"],
        createdAt: doc.data()["createdAt"],
        updatedAt: doc.data()["updatedAt"],
        votes: doc.data()['votes'].cast<String>());
    return idea;
  }

  /// stores an Idea into _idea
  setCurrentIdea(Idea idea) async {
    _idea = idea;
    debugPrint("setCurrentIdea()) ${_idea.id}");
  }

  /// returns an the Idea stored into _idea
  Future<Idea> getCurrentIdea() async {
    debugPrint("getCurrentIdea()) ${_idea.id}");
    return _idea;
  }

  /// adds the _idea to the database
  Future<void> add(Idea idea) async {
    DocumentReference docReference = ideaRef.doc();
    await ideaRef.doc(docReference.id).set(toJson(idea, docReference.id));
    idea = idea.copyWith(
        id: docReference.id, createdAt: currentTimeInSeconds());
    debugPrint('Added idea id: ${idea.id} to DB');
  }

  /// removes _idea from the database
  Future<void> delete(Idea idea) async {
    await ideaRef.doc(idea.id).delete();
    debugPrint('removed idea ${idea.id} from DB');
    idea = null;
  }

  /// updates _idea title and searchable title array in the database and updates _idea with that title
  Future<Idea> updateTitle(Idea idea, title) async {
    await ideaRef
        .doc(idea.id)
        .update({'title': title})
        .then((value) => print("Title Updated for ${idea.id}"))
        .catchError((error) => print("Failed to update title for ${idea.id}: $error"));
    await ideaRef
        .doc(idea.id)
        .update({
          "titleArray": title.toLowerCase().split(new RegExp('\\s+')).toList()
        })
        .then((value) => print("Title Array ${idea.id}"))
        .catchError((error) => print("Failed to update ${idea.id} titleArray: $error"));
    idea = idea.copyWith(title: title);
    updateUpdatedAt(idea);
    debugPrint('updated idea ${idea.id} title in DB');
    return idea;
  }

  /// updates _idea description in the database and updates _idea with that description
  Future<Idea> updateDescription(Idea idea, String description) async {
    await ideaRef
        .doc(idea.id)
        .update({'description': idea.description})
        .then((value) => print("description Updated for ${idea.id}"))
        .catchError((error) => print("Failed to update description: $error"));
    idea = idea.copyWith(description: idea.description);
    updateUpdatedAt(idea);
    return idea;
  }

  /// updates _idea udpatedAt in the database and updates _idea with that update
  /// is called when each field is updated
  Future<Idea> updateUpdatedAt(Idea idea) async {
    await ideaRef.doc(idea.id).update(
        {'updatedAt': DateTime.now().millisecondsSinceEpoch});
    idea = idea.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch);
    debugPrint('updated idea ${idea.id} updatedAt DB');
    return idea;
  }

  /// updates _idea in the database and udpates _idea with that update
  /// Please note that every vote stored in the list must be unique,
  /// or firestore will overwrite stored String vote with
  /// this String vote
  Future<Idea> updateVotes(Idea idea, vote) async {
    await ideaRef.doc(idea.id).update({
      "votes": FieldValue.arrayUnion([vote])}).then((_) async {
      idea = await updateUpdatedAt(idea);
      debugPrint('Added votes: $vote to idea ${idea.id}');
    });
    return idea;
  }

  /// The idea here is to get a document ID from a Stream of multiple documents
  /// then store it to the current _idea for use of display and updates for Idea Services.
  ///
  /// To get the document ID to pass to this function:
  ///  1. StreamBuilder -> store as AsyncSnapshot<QuerySnapshot> snapshot using
  ///    getAllIdeasFromDBStream(), getIdeasFromDBForCurrentMonthStream(), or searchIdeasByTitle()
  ///  2. ListView -> children: snapshot.data.docs.map((document) widgets for each document)
  ///  3. access a specific idea's details "onTapped" with this method passing "document.id"
  ///     to this method
  Future<Idea> getIdeaFromDBDocument(String documentId) async {
    Idea idea;
    DocumentSnapshot doc;
    await ideaRef.doc(documentId).get().then((document) {
      if (document.exists) {
        doc = document;
        print('Document data: ${doc.data()}');
        idea = fromFirestore(doc);
      } else {
        print('Document does not exist on the database');
      }
    });
    print(idea.toString());
    return idea;
  }

  ///get _idea as a stream, returns Instance of '_MapStream<DocumentSnapshot, String>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.getIdeasFromDBForCurrentMonthStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  geIdeaAsStream(Idea idea) async {
    debugPrint('getCurrentIdeaFromDBStream() performing...');
    return ideaRef.doc(idea.id).get().asStream();
  }

  ///get all idea documents from database,returns Instance of '_MapStream<QuerySnapshotPlatform, QuerySnapshot>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.getIdeasFromDBForCurrentMonthStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getAllIdeasFromDBStream() async {
    debugPrint('getAllIdeasFromDBStream() performing...');
    return ideaRef.snapshots();
  }

  /// returns all ideas that were created within the last month as stream of
  /// current day/time - 1 month.
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.getIdeasFromDBForCurrentMonthStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getIdeasFromDBForCurrentMonthStream() async {
    debugPrint('getIdeasFromDBForCurrentMonthStream() performing...');
    return ideaRef.where('createdAt',
        isGreaterThanOrEqualTo:
            currentTimeInSeconds() - 2629743).snapshots();
  }

  ///Used to search all ideas by title and returns Instance of 'Future<List<QuerySnapshot>>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.searchIdeasByTitle(String searchTerm),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  searchIdeasByTitle(String search) {
    debugPrint('searchIdeasByTitle() performing...');
    return ideaRef
        .where('titleArray', arrayContains: search.toLowerCase())
        .snapshots();
  }
}
