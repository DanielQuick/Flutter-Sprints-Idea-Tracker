import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/idea.dart';

///for this service class, users of this class do not have to worry about the updatedAt
///or createdAt variables within the Idea object

///Use this enum to update parts of the Idea Object
enum UpdateIdea {title, description, vote}

class IdeaService {
  ///create variable instances for use
  final _ideaRef = FirebaseFirestore.instance.collection("ideas");

  /// adds the idea to the database and returns that idea
  Future<Idea> create(Idea idea) async {
    DocumentReference docReference = _ideaRef.doc();
    await _ideaRef.doc(docReference.id).set(_toJson(idea, docReference.id));
    idea =
        idea.copyWith(id: docReference.id, createdAt: DateTime.now().millisecondsSinceEpoch);
    debugPrint('Added idea id: ${idea.id} to DB');
    return idea;
  }

  ///Switch to update idea object...use case: ideaService.update(idea, title, "new Title');
  ///String updateWhat should equal 'title' or 'description' or 'vote' only
  ///returns the updated idea
  Future<Idea> update(Idea idea, UpdateIdea update, String updateString) async {
    switch (update) {
      case UpdateIdea.title:
        {
          idea = await _updateTitle(idea, updateString);
          return idea;
        }
        break;
      case UpdateIdea.description:
        {
          idea = await _updateDescription(idea, updateString);
          return idea;
        }
        break;
      case UpdateIdea.vote:
        {
          idea = await _updateVotes(idea, updateString);
          return idea;
        }
        break;
      default:
        {
          print(
              'Nothing was updated, please use title, description, or vote to update your idea.');
          idea = await get(idea.id);
          return idea;
        }
    }
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
  Future<Idea> get(String documentId) async {
    Idea idea;
    await _ideaRef.doc(documentId).get().then((document) {
      if (document.exists) {
        print('Document data: ${document.data()}');
        idea = _fromFirestore(document);
      } else {
        print('Document does not exist on the database');
      }
    });
    print(idea.toString());
    return idea;
  }

  /// returns all ideas that were created for the current month as stream of
  /// current day/time - 1 month.
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.getIdeasFromDBForCurrentMonthStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getAll() async {
    DateTime dateTime = DateTime.now();
    Duration days = new Duration(days:dateTime.day-1);
    debugPrint('getIdeasFromDBForCurrentMonthStream() performing...');
    return _ideaRef
        .where('createdAt',
        isGreaterThanOrEqualTo: dateTime.subtract(days).millisecondsSinceEpoch)
        .snapshots();
  }

  /// removes idea from the database and returns that idea
  Future<void> delete(Idea idea) async {
    await _ideaRef.doc(idea.id).delete();
    debugPrint('removed idea ${idea.id} from DB');
    idea = null;
  }

  ///used to input the idea into the database.
  ///This is only used the first time an idea is input into the database
  _toJson(Idea idea, String id) {
    return {
      "id": id,
      "title": idea.title,
      "titleArray": idea.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": idea.description,
      "createdAt": idea.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      "updatedAt": idea.updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      "votes": idea.votes ?? new List<String>(),
    };
  }

  ///Create Idea object from Firestore DocumentSnapshot
  _fromFirestore(DocumentSnapshot doc) {
    Idea idea = new Idea(
        id: doc.id,
        title: doc.data()["title"],
        description: doc.data()["description"],
        createdAt: doc.data()["createdAt"],
        updatedAt: doc.data()["updatedAt"],
        votes: doc.data()['votes'].cast<String>());
    return idea;
  }

  /// updates _idea udpatedAt in the database and updates _idea with that update
  /// is called when each field is updated
  Future<Idea> _updateUpdatedAt(Idea idea) async {
    await _ideaRef
        .doc(idea.id)
        .update({'updatedAt': DateTime.now().millisecondsSinceEpoch});
    idea = idea.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch);
    debugPrint('updated idea ${idea.id} updatedAt DB');
    return idea;
  }

  /// updates _idea title and searchable title array in the database and updates _idea with that title
  Future<Idea> _updateTitle(Idea idea, String title) async {
    await _ideaRef
        .doc(idea.id)
        .update({'title': title})
        .then((value) => print("Title Updated for ${idea.id}"))
        .catchError(
            (error) => print("Failed to update title for ${idea.id}: $error"));
    await _ideaRef
        .doc(idea.id)
        .update({
          "titleArray": title.toLowerCase().split(new RegExp('\\s+')).toList()
        })
        .then((value) => print("Title Array ${idea.id}"))
        .catchError(
            (error) => print("Failed to update ${idea.id} titleArray: $error"));
    _updateUpdatedAt(idea);
    debugPrint('updated idea ${idea.id} title in DB');
    return idea = await get(idea.id);
  }

  /// updates _idea description in the database and updates _idea with that description
  Future<Idea> _updateDescription(Idea idea, String description) async {
    await _ideaRef
        .doc(idea.id)
        .update({'description': idea.description})
        .then((value) => print("description Updated for ${idea.id}"))
        .catchError((error) => print("Failed to update description: $error"));
    _updateUpdatedAt(idea);
    return idea = await get(idea.id);
  }

  /// updates _idea in the database and udpates _idea with that update
  /// Please note that every vote stored in the list must be unique,
  /// or firestore will overwrite stored String vote with
  /// this String vote
  Future<Idea> _updateVotes(Idea idea, vote) async {
    await _ideaRef.doc(idea.id).update({
      "votes": FieldValue.arrayUnion([vote])
    }).then((_) async {
      idea = await _updateUpdatedAt(idea);
      await new Future.delayed(const Duration(microseconds: 5));
      debugPrint('Added votes: $vote to idea ${idea.id}');
    });
    return idea = await get(idea.id);
  }

  ///get _idea as a stream, returns Instance of '_MapStream<DocumentSnapshot, String>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.getIdeasFromDBForCurrentMonthStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getAsStream(Idea idea) async {
    debugPrint('getCurrentIdeaFromDBStream() performing...');
    return _ideaRef.doc(idea.id).get().asStream();
  }

  ///get all idea documents from database,returns Instance of '_MapStream<QuerySnapshotPlatform, QuerySnapshot>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.getIdeasFromDBForCurrentMonthStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getAllIdeas() async {
    debugPrint('getAllIdeasFromDBStream() performing...');
    return _ideaRef.snapshots();
  }

  ///Used to search all ideas by title and returns Instance of 'Future<List<QuerySnapshot>>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.searchIdeasByTitle(String searchTerm),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  searchByTitle(String search) {
    debugPrint('searchIdeasByTitle() performing...');
    return _ideaRef
        .where('titleArray', arrayContains: search.toLowerCase())
        .snapshots();
  }
}
