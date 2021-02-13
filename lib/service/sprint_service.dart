import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/sprint.dart';

///Use these enums to update parts of the Sprint Object
enum UpdateSprint {
  title,
  description,
  addPotentialLeader,
  deletePotentialLeader,
  member,
  teamLeader
}
enum UpdatePost { create, delete }

class SprintService {
  ///create variable instances for use
  static CollectionReference sprintRef;

  ///this initializes the class variables
  initialize() {
    sprintRef = FirebaseFirestore.instance.collection("sprints");
  }

  ///adds Sprint sprint to the database
  Future<Sprint> create(Sprint sprint) async {
    DocumentReference docReference = sprintRef.doc();
    sprint = sprint.copyWith(id: docReference.id);
    await sprintRef
        .doc(docReference.id)
        .set(_sprintToJson(sprint, docReference.id));
    debugPrint('Added sprint id: ${sprint.id} to DB');
    return sprint = await get(sprint.id);
  }

  ///removes/deletes class Sprint sprint from the database
  Future<void> delete(Sprint sprint) async {
    await sprintRef.doc(sprint.id).delete();
    debugPrint('removed Sprint ${sprint.id} from DB');
  }

  /// Uses the switch to update multiple properties within a sprint
  /// Requires use of enum above this class
  /// Use Case example:
  /// _sprintServices.update(sprint, [UpdateSprint.title,
  ///      UpdateSprint.description], ['New Title', 'New Description sequence'])
  Future<Sprint> update(Sprint sprint, List<UpdateSprint> updates,
      List<String> updateStrings) async {
    if (updates.length == updateStrings.length) {
      for (var i = 0; i < updates.length; i++) {
        sprint = await _update(sprint, updates[i], updateStrings[i]);
      }
      return sprint;
    } else {
      debugPrint(
          'The update will not work unless both lists have the same length');
    }
    return sprint;
  }

  /// Switch to update sprint object...
  /// use case: sprintService.update(idea, UpdateSprint.title, 'new Title');
  /// returns the updated Sprint
  Future<Sprint> _update(
      Sprint sprint, UpdateSprint update, String updateString) async {
    Sprint updatedSprint = sprint;
    switch (update) {
      case UpdateSprint.title:
        {
          updatedSprint = await _updateTitle(updatedSprint, updateString);
          return updatedSprint;
        }
        break;
      case UpdateSprint.description:
        {
          updatedSprint = await _updateDescription(updatedSprint, updateString);
          return updatedSprint;
        }
        break;
      case UpdateSprint.teamLeader:
        {
          updatedSprint = await _updateTeamLeader(updatedSprint, updateString);
          return updatedSprint;
        }
        break;
      case UpdateSprint.addPotentialLeader:
        {
          updatedSprint = await _addPotentialLeaders(updatedSprint, updateString);
          return updatedSprint;
        }
        break;
      case UpdateSprint.deletePotentialLeader:
        {
          updatedSprint = await _deletePotentialLeaders(updatedSprint, updateString);
          return updatedSprint;
        }
        break;
      case UpdateSprint.member:
        {
          /// This checks to see if user already a member.
          /// To get the number of members use list.length(); on the member list
          /// within the Sprint object
          if (!updatedSprint.members.contains(updateString)) {
            updatedSprint = await _addMember(updatedSprint, updateString);
            debugPrint('User $updateString added to member list for this sprint.');
          } else {
            debugPrint('User $updateString is already member of this sprint.');
            updatedSprint = await _deleteMember(updatedSprint, updateString);
            debugPrint('User $updateString removed from voters for this idea.');
          }
          return updatedSprint;
        }
        break;
      default:
        {
          print(
              "Nothing was updated, please use Enum UpdateSprint your Sprint ${updatedSprint.id}.");
          return updatedSprint;
        }
    }
  }

  /// update posts within Sprint
  ///...to update a post first delete post then create new post
  /// list class here just adds new posts to the end of the list,
  /// Firestore can only use arrays for lists so it follows typical array
  /// addition and deletion functionality
  Future<Sprint> updatePost(
      Sprint sprint, UpdatePost updatePost, SprintPost sprintPost) async {
    switch (updatePost) {
      case UpdatePost.create:
        {
          sprint = await _createPost(sprint, sprintPost);
          return sprint;
        }
        break;
      case UpdatePost.delete:
        {
          sprint = await _deletePost(sprint, sprintPost);
          return sprint;
        }
        break;
      default:
        {
          print(
              "Nothing was updated, please use Enum UpdatePost to update your Sprint ${sprint.id}.");
          return sprint;
        }
        break;
    }
  }

  /// Returns requested Sprint object
  /// Use case example: Sprint sprint = get('TodjI69eQV4xwSkuQx2T');
  /// The methodology here is to get a document ID from a Stream/List of
  /// multiples
  ///
  /// One of many ways get the document ID to pass to this function:
  ///  1. FutureBuilder -> store as AsyncSnapshot<QuerySnapshot> snapshot using
  ///     getAll()
  ///  2. ListView -> children: snapshot.data.docs.map((document) widgets for
  ///     each document)
  ///  3. access a specific idea's details "onTapped" with this function by
  ///     passing "document.id" to this function
  Future<Sprint> get(String documentId) async {
    DocumentSnapshot doc;
    Sprint sprint;
    await sprintRef.doc(documentId).get().then((document) async {
      if (document.exists) {
        doc = document;
        sprint = _fromFirestore(doc);
      } else {
        print('Document does not exist on the database');
      }
    });
    return sprint;
  }

  ///get all sprint documents from database,returns List<Sprints>'
  Future<List<Sprint>> getAll() async {
    debugPrint('getAllSprintsFromDBStream() performing...');
    QuerySnapshot querySnapshots = await sprintRef
        .get()
        .catchError((error) => debugPrint("Failed to get all Sprints: $error"));
    return querySnapshots.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  /// returns all ideas that were created for the current month as Future List<Sprint>
  Future<List<Sprint>> getAllCurrent() async {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month);
    debugPrint('getAllCurrent() performing...');
    QuerySnapshot querySnapshot = await sprintRef
        .where('createdAt',
        isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
        .get()
        .catchError(
            (error) => print("Failed to get all Current Sprints: $error"));
    return querySnapshot.docs.map((doc) => _fromFirestore(doc)).toList();
  }

  ///Create Sprint object from a Firestore DocumentSnapshot
  Sprint _fromFirestore(DocumentSnapshot doc) {
    ///converts _InternalLinkedHashMap<String, dynamic> to List<SprintPost>
    List<Map<String, dynamic>> sprintPostDataMaps =
    List<Map<String, dynamic>>.from(doc.data()['posts']);
    List<SprintPost> sprintPostList = sprintPostDataMaps
        .map((post) => _sprintPostFromFirestore(post))
        .toList()
        .cast<SprintPost>();
    Sprint sprint = new Sprint(
      id: doc.id,
      title: doc.data()["title"],
      description: doc.data()["description"],
      teamLeader: doc.data()['teamLeader'],
      createdAt: doc.data()["createdAt"],
      updatedAt: doc.data()["updatedAt"],
      members: doc.data()['members'].cast<String>(),
      potentialLeaders: doc.data()['potentialLeaders'].cast<String>(),
      posts: sprintPostList,
    );
    return sprint;
  }

  ///convert a SprintPost object from Json Map for Firestore consumption
  SprintPost _sprintPostFromFirestore(post) {
    SprintPost sprintPost = new SprintPost(
      id: post['id'],
      title: post['title'],
      content: post['content'],
      createdAt: post['createdAt'],
    );
    return sprintPost;
  }

  ///convert SprintPost object to Json Map for Firestore consumption
  _sprintPostToJson(SprintPost post) {
    return {
      'id': post.id,
      'title': post.title,
      'content': post.content,
      'createdAt': post.createdAt,
    };
  }

  ///convert Sprint object to Json Map for Firestore consumption
  _sprintToJson(Sprint sprint, String id) {
    return {
      'id': sprint.id ?? id,
      "title": sprint.title ?? '',
      "titleArray":
      sprint.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": sprint.description ?? '',
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "teamLeader": sprint.teamLeader ?? '',
      "updatedAt": sprint.updatedAt ?? DateTime.now().millisecondsSinceEpoch,
      "potentialLeaders": sprint.potentialLeaders ?? new List<String>(),
      "members": sprint.members ?? new List<String>(),
      "posts": sprint.posts ?? new List<SprintPost>(),
    };
  }

  ///returns int for updateUpdatedAt();
  _getUpdatedAt() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// updates Sprint sprint title in database
  Future<Sprint> _updateTitle(Sprint sprint, String title) async {
    await sprintRef.doc(sprint.id).update({'title': title});
    await sprintRef.doc(sprint.id).update(
        {"titleArray": title.toLowerCase().split(new RegExp('\\s+')).toList()});
    await _updateUpdatedAt(sprint);
    debugPrint('updated sprint ${sprint.id} title in DB');
    return sprint = await get(sprint.id);
  }

  /// updates Sprint sprint description in database
  Future<Sprint> _updateDescription(Sprint sprint, String description) async {
    await sprintRef.doc(sprint.id).update({'description': description});
    sprint = sprint.copyWith(description: description);
    await _updateUpdatedAt(sprint);
    debugPrint('updated description DB');
    return sprint = await get(sprint.id);
  }

  /// updates class sprint updatedAt in database
  Future<Sprint> _updateUpdatedAt(Sprint sprint) async {
    await sprintRef
        .doc(sprint.id)
        .update({'updatedAt': _getUpdatedAt()}).then((_) {
      debugPrint('updatedAt: ${_getUpdatedAt()} for sprint ${sprint.id}');
    }).catchError((error) => debugPrint("Failed to update updatedAt: $error"));
    return sprint = await get(sprint.id);
  }

  /// updates class sprint updateTeamLeader in database
  Future<Sprint> _updateTeamLeader(Sprint sprint, String teamLeader) async {
    await sprintRef
        .doc(sprint.id)
        .update({'teamLeader': teamLeader}).then((_) async {
      debugPrint('Updated teamLeader: $teamLeader for sprint ${sprint.id}');
      await _updateUpdatedAt(sprint);
    }).catchError((error) => debugPrint("Failed to update teamLeader: $error"));
    return sprint = await get(sprint.id);
  }

  /// updates sprint potentialLeaders in database
  /// Please note that every potentialLeader stored in the list must be unique,
  /// or firestore will overwrite stored String potentialLeaders with
  /// this String potentialLeaders
  ///Returns updated sprint object
  Future<Sprint> _addPotentialLeaders(
      Sprint sprint, String potentialLeader) async {
    await sprintRef.doc(sprint.id).update({
      "potentialLeaders": FieldValue.arrayUnion(['$potentialLeader'])
    }).then((_) async {
      debugPrint(
          'Added potentialLeader: $potentialLeader to sprint ${sprint.id}');
      await _updateUpdatedAt(sprint);
    }).catchError(
            (error) => debugPrint("Failed to add potential leader: $error"));

    ///to get and store correct properties into class sprint object
    return sprint = await get(sprint.id);
  }

  /// updates sprint potentialLeaders list in database
  ///Returns updated sprint object
  Future<Sprint> _deletePotentialLeaders(
      Sprint sprint, String potentialLeader) async {
    sprintRef.doc(sprint.id).update({
      "potentialLeaders": FieldValue.arrayRemove(['$potentialLeader'])
    }).then((_) async {
      debugPrint(
          'Deleted potentialLeaders: $potentialLeader to sprint ${sprint.id}');
      await _updateUpdatedAt(sprint);
    }).catchError(
            (error) => debugPrint("Failed to delete potential leader $error"));

    ///to get and store correct properties into class sprint object
    return sprint = await get(sprint.id);
  }

  /// updates sprint in database
  /// Please note that every member stored in the list must be unique,
  /// or firestore will overwrite stored String member with
  /// this String member
  Future<Sprint> _addMember(Sprint sprint, String member) async {
    sprintRef.doc(sprint.id).update({
      "members": FieldValue.arrayUnion(['$member'])
    }).then((_) async {
      debugPrint('Added member: $member to sprint ${sprint.id}');
      await _updateUpdatedAt(sprint);
    }).catchError((error) => debugPrint("Failed to add member: $error"));

    ///return sprint to user
    return sprint = await get(sprint.id);
  }

  /// remove sprint members from database
  /// Please note that every member stored in the list must be unique,
  /// or firestore will overwrite stored String member with
  /// this String member
  ///Returns updated sprint object
  Future<Sprint> _deleteMember(Sprint sprint, String member) async {
    sprintRef.doc(sprint.id).update({
      "members": FieldValue.arrayRemove(['$member'])
    }).then((_) async {
      debugPrint('removed member: $member from sprint ${sprint.id}');
      await _updateUpdatedAt(sprint);
    }).catchError((error) => debugPrint("Failed to remove member: $error"));

    return sprint = await get(sprint.id);
  }

  /// adds SprintPost object to sprint in database
  /// Please note that every SprintPost stored in the list must be unique,
  /// or firestore will overwrite stored SprintPost with
  /// this SprintPost
  /// Returns updated sprint object
  Future<Sprint> _createPost(Sprint sprint, SprintPost post) async {
    sprintRef.doc(sprint.id).update({
      "posts": FieldValue.arrayUnion([_sprintPostToJson(post)])
    }).then((_) async {
      debugPrint('Added post: $post to sprint ${sprint.id}');
      await _updateUpdatedAt(sprint);
    }).catchError((error) => debugPrint("Failed to create Post: $error"));

    return sprint = await get(sprint.id);
  }

  /// deletes SprintPost object to sprint in database
  /// uses the specific sprint post object
  /// returns the updated sprint object
  Future<Sprint> _deletePost(Sprint sprint, SprintPost post) async {
    sprintRef.doc(sprint.id).update({
      "posts": FieldValue.arrayRemove([_sprintPostToJson(post)])
    }).then((_) {
      debugPrint('Removed post: $post from sprint ${sprint.id}');
      _updateUpdatedAt(sprint);
    }).catchError((error) => debugPrint("Failed to delete post: $error"));

    return sprint = await get(sprint.id);
  }
}