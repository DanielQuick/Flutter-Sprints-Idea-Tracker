import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/sprint.dart';

///Use these enums to update parts of the Sprint Object
enum UpdateSprint {
  title,
  description,
  addPotentialLeader,
  deletePotentialLeader,
  addMember,
  deleteMember,
  teamLeader
}
enum UpdatePost { create, delete }

class SprintService {
  ///create variable instances for use
  CollectionReference sprintRef;

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

  ///Switch to update sprint object...use case: sprintService.update(idea, UpdateSprint.title, 'new Title');
  ///returns the updated Sprint
  Future<Sprint> update(
      Sprint sprint, UpdateSprint update, String updateString) async {
    switch (update) {
      case UpdateSprint.title:
        {
          sprint = await _updateTitle(sprint, updateString);
          return sprint;
        }
        break;
      case UpdateSprint.description:
        {
          sprint = await _updateDescription(sprint, updateString);
          return sprint;
        }
        break;
      case UpdateSprint.teamLeader:
        {
          sprint = await _updateTeamLeader(sprint, updateString);
          return sprint;
        }
        break;
      case UpdateSprint.addPotentialLeader:
        {
          sprint = await _addPotentialLeaders(sprint, updateString);
          return sprint;
        }
        break;
      case UpdateSprint.deletePotentialLeader:
        {
          sprint = await _deletePotentialLeaders(sprint, updateString);
          return sprint;
        }
        break;
      case UpdateSprint.addMember:
        {
          sprint = await _addMember(sprint, updateString);
          return sprint;
        }
        break;
      case UpdateSprint.deleteMember:
        {
          sprint = await _deleteMember(sprint, updateString);
          return sprint;
        }
        break;
      default:
        {
          print("Nothing was updated, please use 'title' 'description' "
              "'potentialLeader' 'addMember' 'deleteMember' 'teamLeader' "
              "to update your Sprint ${sprint.id}.");
          return sprint;
        }
    }
  }

  ///update posts within Sprint
  ///...to update a post first delete post then create new post
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
              "Nothing was updated, please use 'create', 'delete' to update your Sprint ${sprint.id}.");
          return sprint;
        }
    }
  }

  /// The idea here is to get a document ID from a Stream of multiple documents
  /// then store it to the current sprint for use of display and updates for Sprint Services.
  ///
  /// To get the document ID to pass to this function:
  ///  1. StreamBuilder -> store as AsyncSnapshot<QuerySnapshot> snapshot using
  ///    getAllIdeasFromDBStream(), getIdeasFromDBForCurrentMonthStream(), or searchIdeasByTitle()
  ///  2. ListView -> children: snapshot.data.docs.map((document) widgets for each document)
  ///  3. access a specific sprint's details "onTapped" with this method passing "document.id"
  ///     to this method
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

  ///Create Sprint object from a Firestore DocumentSnapshot
  Sprint _fromFirestore(DocumentSnapshot doc) {
    ///converts _InternalLinkedHashMap<String, dynamic> to List<SprintPost>
    List<Map<String, dynamic>> sprintPostDataMaps =
        List<Map<String, dynamic>>.from(doc.data()['posts']);
    List<SprintPost> sprintPostList = sprintPostDataMaps
        .map((post) => _sprintPostFromJson(post))
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
  _sprintPostFromJson(post) {
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
      "title": sprint.title,
      "titleArray":
          sprint.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": sprint.description,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "teamLeader": sprint.teamLeader,
      "updatedAt": sprint.updatedAt,
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
    await sprintRef.doc(sprint.id).update({'updatedAt': _getUpdatedAt()});
    sprint = sprint.copyWith(updatedAt: _getUpdatedAt());
    debugPrint('updated updatedAt DB');
    return sprint = await get(sprint.id);
  }

  /// updates class sprint updateTeamLeader in database
  Future<Sprint> _updateTeamLeader(Sprint sprint, String teamLeader) async {
    await sprintRef.doc(sprint.id).update({'teamLeader': teamLeader});
    sprint = sprint.copyWith(teamLeader: teamLeader);
    _updateUpdatedAt(sprint);
    debugPrint('updated teamLeader DB');
    return sprint = await get(sprint.id);
  }

  /// updates class sprint potentialLeaders in database
  /// Please note that every potentialLeader stored in the list must be unique,
  /// or firestore will overwrite stored String potentialLeaders with
  /// this String potentialLeaders
  Future<Sprint> _addPotentialLeaders(
      Sprint sprint, String potentialLeader) async {
    sprintRef.doc(sprint.id).update({
      "potentialLeaders": FieldValue.arrayUnion(['$potentialLeader'])
    }).then((_) {
      debugPrint(
          'Added potentialLeader: $potentialLeader to sprint ${sprint.id}');
    });
    _updateUpdatedAt(sprint);

    ///to get and store correct properties into class sprint object
    return sprint = await get(sprint.id);
  }

  Future<Sprint> _deletePotentialLeaders(
      Sprint sprint, String potentialLeader) async {
    sprintRef.doc(sprint.id).update({
      "potentialLeaders": FieldValue.arrayRemove(['$potentialLeader'])
    }).then((_) {
      debugPrint(
          'Deleted potentialLeaders: $potentialLeader to sprint ${sprint.id}');
    });
    _updateUpdatedAt(sprint);

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
    }).then((_) {
      debugPrint('Added member: $member to sprint ${sprint.id}');
    });
    _updateUpdatedAt(sprint);

    ///return sprint to user
    return sprint = await get(sprint.id);
  }

  /// remove sprint members from database
  /// Please note that every member stored in the list must be unique,
  /// or firestore will overwrite stored String member with
  /// this String member
  Future<Sprint> _deleteMember(Sprint sprint, String member) async {
    sprintRef.doc(sprint.id).update({
      "members": FieldValue.arrayRemove(['$member'])
    }).then((_) {
      debugPrint('removed member: $member from sprint ${sprint.id}');
    });
    _updateUpdatedAt(sprint);

    ///to get and store correct properties into class sprint object
    return sprint = await get(sprint.id);
  }

  /// adds SprintPost object to sprint in database
  /// Please note that every SprintPost stored in the list must be unique,
  /// or firestore will overwrite stored SprintPost with
  /// this SprintPost
  Future<Sprint> _createPost(Sprint sprint, SprintPost post) async {
    sprintRef.doc(sprint.id).update({
      "posts": FieldValue.arrayUnion([_sprintPostToJson(post)])
    }).then((_) {
      debugPrint('Added post: $post to sprint ${sprint.id}');
    });
    _updateUpdatedAt(sprint);

    ///to get and store correct properties into class sprint object
    return sprint = await get(sprint.id);
  }

  /// deletes SprintPost object to sprint in database
  Future<Sprint> _deletePost(Sprint sprint, SprintPost post) async {
    sprintRef.doc(sprint.id).update({
      "posts": FieldValue.arrayRemove([_sprintPostToJson(post)])
    }).then((_) {
      debugPrint('Removed post: $post from sprint ${sprint.id}');
    });
    _updateUpdatedAt(sprint);

    ///to get and store correct properties into class sprint object
    return sprint = await get(sprint.id);
  }

  ///get all sprint documents from database,returns Instance of '_MapStream<QuerySnapshotPlatform, QuerySnapshot>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: sprintService.getAll(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getAll() async {
    debugPrint('getAllSprintsFromDBStream() performing...');
    return sprintRef.snapshots();
  }
}
