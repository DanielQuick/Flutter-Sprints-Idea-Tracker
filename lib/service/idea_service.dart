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
  /// Use case example: create(idea);
  Future<Idea> create(Idea idea) async {
    DocumentReference docReference = _ideaRef.doc();
    await _ideaRef
        .doc(docReference.id)
        .set(await _toJson(idea, docReference.id));
    idea = idea.copyWith(
        id: docReference.id, createdAt: DateTime.now().millisecondsSinceEpoch);
    debugPrint('Added idea id: ${idea.id} to DB');
    return idea;
  }

  Future<Idea> update(
      Idea idea, List<UpdateIdea> updates, List<String> updateStrings) async {
    for (var i = 0; i < updates.length; i++) {
      idea = await _update(idea, updates[i], updateStrings[i]);
    }

    return idea;
  }

  ///Returns the updated idea
  ///Switch to update idea object...this uses the Enum UpdateIdea above
  ///this class.
  ///use case example: _ideaService.update(idea, Update.title, "new Title');
  Future<Idea> _update(
      Idea idea, UpdateIdea update, String updateString) async {
    User user;
    debugPrint(idea.toString());
    Idea updatedIdea = await get(idea.id).then((idea) async {
      user = await _getUser();
      return idea;
    });
    switch (update) {
      case UpdateIdea.title:
        {
          if (user.id == idea.creatorId) {
            updatedIdea = await _updateTitle(idea, updateString);
          } else {
            debugPrint(
                'This idea\'s Title cannot be updated.  Logged in user is not the owner of the idea.');
          }
          return updatedIdea;
        }
        break;
      case UpdateIdea.description:
        {
          if (user.id == idea.creatorId) {
            updatedIdea = await _updateDescription(idea, updateString);
          } else {
            debugPrint(
                'This idea\'s Description cannot be updated.  Logged in user is not the owner of the idea.');
          }
          return updatedIdea;
        }
        break;
      case UpdateIdea.vote:
        {
          /// This checks to see if user already voted.
          /// To get the number of votes use list.length(); on the voter list
          /// within the Idea object
          if (!updatedIdea.voters.contains(user.id)) {
            updatedIdea = await _addVoters(idea);
            debugPrint('User ${user.id} added to voters for this idea.');
          } else {
            debugPrint('User ${user.id} has already voted for this idea.');
            updatedIdea = await _deleteVoters(idea);
            debugPrint('User ${user.id} removed from voters for this idea.');
          }
          return updatedIdea;
        }
        break;
      default:
        {
          debugPrint('Nothing was updated, please try again.');
          updatedIdea = await get(idea.id);
          return updatedIdea;
        }
    }
  }

  /// Returns requested Idea object
  /// Use case example: Idea idea = get('jmECu4ce5aTWL6EnCpP2');
  /// The methodology here is to get a document ID from a Stream/List of multiple documents
  ///
  /// To get the document ID to pass to this function:
  ///  1. StreamBuilder/FutureBuilder -> store as AsyncSnapshot<QuerySnapshot> snapshot using
  ///    getAll(), getIdeasFromDBForCurrentMonthStream(), or searchIdeasByTitle()
  ///  2. ListView -> children: snapshot.data.docs.map((document) widgets for each document)
  ///  3. access a specific idea's details "onTapped" with this function by passing "document.id"
  ///     to this function
  Future<Idea> get(String documentId) async {
    Idea idea;
    await _ideaRef.doc(documentId).get().then((document) {
      if (document.exists) {
        idea = _fromFirestore(document);
        return idea;
      } else {
        debugPrint('Document does not exist on the database');
      }
    }).catchError((error) => debugPrint("Failed to get Idea: $error"));
    debugPrint(idea.toString());
    return idea;
  }

  /// returns all ideas that were created for the current month as Future List<Idea>
  Future<List<Idea>> getAll() async {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month);
    debugPrint('getAll() performing...');
    QuerySnapshot querySnapshot = await _ideaRef
        .where('createdAt',
            isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
        .get()
        .catchError((error) => print("Failed to get all Ideas: $error"));
    return querySnapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  /// removes idea from the database and returns that idea
  /// Use case Example: delete(idea);
  Future<Idea> delete(Idea idea) async {
    await _ideaRef
        .doc(idea.id)
        .delete()
        .catchError((error) => debugPrint("Failed to delete Idea: $error"));
    debugPrint('removed idea ${idea.id} from DB');
    return idea = null;
  }

  ///Below are all of the functions within this class for internal use

  ///gets user from Authentication Service to utilize the user ID for idea voting
  Future<User> _getUser() async {
    AuthenticationService _auth = locator<AuthenticationService>();
    User user = _auth.getAuthenticatedUser();
    debugPrint('Idea  _getUser(): ' + user.id);
    return user;
  }

  ///used to input the idea into the database.
  ///This is only used the first time an idea is input into the database
  Future<Map<String, dynamic>> _toJson(Idea idea, String id) async {
    User user = await _getUser();
    return {
      "id": id,
      "title": idea.title,
      "titleArray": idea.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "creatorId": user.id,
      "description": idea.description,
      "createdAt": idea.createdAt ?? DateTime.now().millisecondsSinceEpoch,
      "updatedAt": idea.updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      "voters": idea.voters ?? new List<String>(),
    };
  }

  ///Creates Idea object from Firestore DocumentSnapshot
  Idea _fromFirestore(DocumentSnapshot doc) {
    Idea idea = new Idea(
        id: doc.id,
        title: doc.data()["title"],
        description: doc.data()["description"],
        creatorId: doc.data()["creatorId"],
        createdAt: doc.data()["createdAt"],
        updatedAt: doc.data()["updatedAt"],
        voters: doc.data()["voters"].cast<String>());
    return idea;
  }

  /// updates _idea udpatedAt in the database
  /// is called when each field is updated
  /// Returns the updated Idea object
  Future<Idea> _updateUpdatedAt(Idea idea) async {
    await _ideaRef
        .doc(idea.id)
        .update({'updatedAt': DateTime.now().millisecondsSinceEpoch})
        .then((value) => debugPrint("updatedAt Updated for ${idea.id}"))
        .catchError(
            (error) => debugPrint("Failed to update updatedAt: $error"));
    debugPrint('updated idea ${idea.id} updatedAt DB');
    return idea = await get(idea.id);
  }

  /// updates Idea object title and searchable title array in the database
  /// Returns the updated Idea object
  Future<Idea> _updateTitle(Idea idea, String title) async {
    await _ideaRef
        .doc(idea.id)
        .update({'title': title})
        .then((value) => debugPrint("Title Updated for ${idea.id}"))
        .catchError((error) =>
            debugPrint("Failed to update title for ${idea.id}: $error"));
    await _ideaRef
        .doc(idea.id)
        .update({
          "titleArray": title.toLowerCase().split(new RegExp('\\s+')).toList()
        })
        .then((value) => debugPrint("Title Array ${idea.id}"))
        .catchError((error) =>
            debugPrint("Failed to update ${idea.id} titleArray: $error"));
    _updateUpdatedAt(idea);
    debugPrint('updated idea ${idea.id} title in DB');
    return idea = await get(idea.id);
  }

  /// updates Idea object description in the database
  /// Returns the updated Idea object
  Future<Idea> _updateDescription(Idea idea, String description) async {
    await _ideaRef
        .doc(idea.id)
        .update({'description': description})
        .then((value) => debugPrint("description Updated for ${idea.id}"))
        .catchError(
            (error) => debugPrint("Failed to update description: $error"));
    _updateUpdatedAt(idea);
    return idea = await get(idea.id);
  }

  /// adds logged in user to the array of voters within firestore
  /// updates passed in Idea object
  /// Returns the updated Idea object
  /// Please note that every user stored in the list must be unique
  /// voters can only vote once per idea
  Future<Idea> _addVoters(Idea idea) async {
    User user = await _getUser();
    await _ideaRef.doc(idea.id).update({
      "voters": FieldValue.arrayUnion([user.id])
    }).then((_) async {
      idea = await _updateUpdatedAt(idea);
      await new Future.delayed(const Duration(microseconds: 5));
      debugPrint('Added voter: $user.id to idea ${idea.id}');
    }).catchError((error) => debugPrint("Failed to add voter: $error"));

    return idea = await get(idea.id);
  }

  /// deletes logged in user from the array of voters within firestore
  /// updates passed in Idea object
  /// Returns updated Idea object
  Future<Idea> _deleteVoters(Idea idea) async {
    User user = await _getUser();
    await _ideaRef.doc(idea.id).update({
      "voters": FieldValue.arrayRemove([user.id])
    }).then((_) async {
      idea = await _updateUpdatedAt(idea);
      await new Future.delayed(const Duration(microseconds: 5));
      debugPrint('Added voter: $user.id to idea ${idea.id}');
    }).catchError((error) => debugPrint("Failed to delete voter: $error"));

    return idea = await get(idea.id);
  }

  ///the below functions are for future use in case someone wants to use streams

  ///get _idea as a stream, returns Instance of '_MapStream<DocumentSnapshot, String>'
  ///Use case example:
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
  ///Use case example:
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
  ///Use case example:
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
