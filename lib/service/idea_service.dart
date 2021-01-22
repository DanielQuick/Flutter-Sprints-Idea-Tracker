import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idea_tracker/service/services.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/model/user.dart';

import '../locator.dart';

///for this service class, users of this class do not have to worry about the updatedAt
///or createdAt variables within the Idea object

///Use this enum to update parts of the Idea Object
enum UpdateIdea { title, description, vote }

class IdeaService {
  ///create variable instances for use
  CollectionReference _ideaRef;

  ///this initializes  the class
  initialize() {
    _ideaRef = FirebaseFirestore.instance.collection("ideas");
  }

  /// adds the idea to the database and returns that idea
  Future<Idea> create(Idea idea) async {
    DocumentReference docReference = _ideaRef.doc();
    await _ideaRef.doc(docReference.id).set(await _toJson(idea, docReference.id));
    idea = idea.copyWith(
        id: docReference.id, createdAt: DateTime.now().millisecondsSinceEpoch);
    debugPrint('Added idea id: ${idea.id} to DB');
    return idea;
  }

  ///gets user from Authentication Service
  User _getUser() {
    AuthenticationService _auth = locator<AuthenticationService>();
    User user = _auth.authenticatedUser();
    print(user.id);
    return user;
  }

  ///Switch to update idea object...this uses the Enum UpdateIdea at the top of
  ///this class.
  ///use case: _ideaService.update(idea, Update.title, "new Title');
  ///returns the updated idea
  Future<Idea> update(Idea idea, UpdateIdea update, String updateString) async {
    User user = _getUser();
    Idea updatedIdea = idea;
    switch (update) {
      case UpdateIdea.title:
        {
          if(user.id == idea.creatorId) {
            updatedIdea = await _updateTitle(idea, updateString);
          }
          return updatedIdea;
        }
        break;
      case UpdateIdea.description:
        {
          if(user.id == idea.creatorId) {
            updatedIdea = await _updateDescription(idea, updateString);
          }
          return updatedIdea;
        }
        break;
      case UpdateIdea.vote:
        {
          ///checks to see if user already voted
          if (!updatedIdea.voters.contains(user.id)) {
            ///adds logged in user to voter list
            updatedIdea = await _updateVoters(idea);
            if (updateString.toLowerCase() == 'yes') {
              updatedIdea = await _updateVoteYes(idea);
            } else if (updateString.toLowerCase() == 'no') {
              updatedIdea = await _updateVoteNo(idea);
            } else {
              print('Vote must be yes or no');
            }
          } else {
            print('User ${user.id} has already voted for this idea.');
          }
          return updatedIdea;
        }
        break;
      default:
        {
          print(
              'Nothing was updated, please try again.');
          updatedIdea = await get(idea.id);
          return updatedIdea;
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
        //print('Document data: ${document.data()}');
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
  ///             stream: _ideaService.getAll(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getAll() async {
    DateTime dateTime = DateTime.now();
    Duration days = new Duration(days: dateTime.day - 1);
    debugPrint('getIdeasFromDBForCurrentMonthStream() performing...');
    return _ideaRef
        .where('createdAt',
            isGreaterThanOrEqualTo:
                dateTime.subtract(days).millisecondsSinceEpoch)
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
  Future<Map<String, dynamic>>_toJson(Idea idea, String id) async{
    User user = _getUser();
    return {
      "id": id,
      "title": idea.title,
      "titleArray": idea.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "creatorId": user.id,
      "description": idea.description,
      "createdAt": idea.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      "updatedAt": idea.updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      "voteYes": idea.voteYes ?? 0,
      "voteNo": idea.voteNo ?? 0,
      "voters": idea.voters ?? new List<String>(),
    };
  }

  ///Create Idea object from Firestore DocumentSnapshot
  _fromFirestore(DocumentSnapshot doc) {
    Idea idea = new Idea(
        id: doc.id,
        title: doc.data()["title"],
        description: doc.data()["description"],
        creatorId: doc.data()["creatorId"],
        createdAt: doc.data()["createdAt"],
        updatedAt: doc.data()["updatedAt"],
        voteYes: doc.data()["voteYes"],
        voteNo: doc.data()["voteNo"],
        voters: doc.data()["voters"].cast<String>());
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
        .update({'description': description})
        .then((value) => print("description Updated for ${idea.id}"))
        .catchError((error) => print("Failed to update description: $error"));
    _updateUpdatedAt(idea);
    return idea = await get(idea.id);
  }

  /// updates _idea in the database and udpates _idea with that update
  /// Please note that every user stored in the list must be unique
  /// voters can only vote once per idea
  Future<Idea> _updateVoters(Idea idea) async {
    User user = _getUser();
    await _ideaRef.doc(idea.id).update({
      "voters": FieldValue.arrayUnion([user.id])
    }).then((_) async {
      idea = await _updateUpdatedAt(idea);
      await new Future.delayed(const Duration(microseconds: 5));
      debugPrint('Added voter: $user.id to idea ${idea.id}');
    });
    return idea = await get(idea.id);
  }

  Future<Idea> _updateVoteYes(Idea idea) async {
    await _ideaRef.doc(idea.id).update({'voteYes': FieldValue.increment(1)});
    return idea = await get(idea.id);
  }

  Future<Idea> _updateVoteNo(Idea idea) async {
    await _ideaRef.doc(idea.id).update({'voteNo': FieldValue.increment(1)});
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
