import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/sprint.dart';

class SprintService {
  ///create variable instances for use
  final sprintRef = FirebaseFirestore.instance.collection("sprints");
  static Sprint _sprint = new Sprint();
  
  ///Create Sprint object from a Firestore DocumentSnapshot
  Sprint fromFirestore(DocumentSnapshot doc) {
    ///converts _InternalLinkedHashMap<String, dynamic> to List<SprintPost>
    List<Map<String, dynamic>> sprintPostDataMaps =
        List<Map<String, dynamic>>.from(doc.data()['posts']);
    List<SprintPost> sprintPostData = sprintPostDataMaps
        .map((post) => sprintPostFromJson(post))
        .toList()
        .cast<SprintPost>();

    Sprint sprint = new Sprint(
      id: doc.id,
      title: doc.data()["title"],
      description: doc.data()["description"],
      createdAt: doc.data()["createdAt"],
      updatedAt: doc.data()["updatedAt"],
      members: doc.data()['members'].cast<String>(),
      potentialLeaders: doc.data()['potentialLeaders'].cast<String>(),
      posts: sprintPostData,
    );
    return sprint;
  }

  ///convert a SprintPost object from Json Map for Firestore consumption
  sprintPostFromJson(post) {
    SprintPost sprintPost = new SprintPost(
      id: post['id'],
      title: post['title'],
      content: post['content'],
      createdAt: post['createdAt'],
    );
    return sprintPost;
  }

  ///convert SprintPost object to Json Map for Firestore consumption
  sprintPostToJson(SprintPost post) {
    return {
      'id': post.id,
      'title': post.title,
      'content': post.content,
      'createdAt': post.createdAt,
    };
  }

  ///convert Sprint object to Json Map for Firestore consumption
  sprintToJson(Sprint _sprint, String id) {
    return {
      'id': _sprint.id ?? id,
      "title": _sprint.title,
      "titleArray":
          _sprint.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": _sprint.description,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "updatedAt": _sprint.updatedAt,
      "potentialLeaders": _sprint.potentialLeaders ?? new List<String>(),
      "members": _sprint.members ?? new List<String>(),
      "posts": new List<SprintPost>(),
    };
  }

  ///returns int for updateUpdatedAt();
  getUpdatedAt() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///Sets Sprint _sprint for this class usage
  Future setCurrentSprint(Sprint sprint) async {
    _sprint = sprint;
    debugPrint('Added ${sprint.id} as current sprint');
  }
  
  ///returns current sprint
  Future<Sprint> getCurrentSprint() async {
    return _sprint;
  }

  ///adds Sprint _sprint to the database
  Future<Sprint> add(Sprint sprint) async {
    DocumentReference docReference = sprintRef.doc();
    sprint = sprint.copyWith(id: docReference.id);
    await sprintRef.doc(docReference.id).set(sprintToJson(sprint, docReference.id));
    debugPrint('Added sprint id: ${sprint.id} to DB');
    return sprint = await getSprint(sprint.id);
  }

  ///removes/deletes class Sprint _sprint from the database
  Future<void> deleteFromDB(Sprint sprint) async {
    await sprintRef.doc(sprint.id).delete();
    debugPrint('removed Sprint ${sprint.id} from DB');
  }
  /// updates class _sprint title in database
  Future<Sprint> updateTitle(Sprint sprint, String title) async {
    await sprintRef.doc(sprint.id).update({'title': title});
    await sprintRef.doc(sprint.id).update({"titleArray":
    title.toLowerCase().split(new RegExp('\\s+')).toList()});
    await updateUpdatedAt(sprint);
    debugPrint('updated sprint ${sprint.id} title in DB');
    return sprint = await getSprint(sprint.id);
  }

  /// updates class _sprint description in database
  Future<Sprint> updateDescription(Sprint sprint, String description) async {
    await sprintRef.doc(sprint.id).update({'description': description});
    sprint = sprint.copyWith(description: description);
    await updateUpdatedAt(sprint);
    debugPrint('updated description DB');
    return sprint = await getSprint(sprint.id);
  }

  /// updates class _sprint updatedAt in database
  Future<void> updateUpdatedAt(Sprint sprint) async {
    await sprintRef.doc(_sprint.id).update({'updatedAt': getUpdatedAt()});
    _sprint = _sprint.copyWith(updatedAt: getUpdatedAt());
    debugPrint('updated updatedAt DB');
    return sprint = await getSprint(sprint.id);
  }

  /// updates class _sprint updateTeamLeader in database
  Future<void> updateTeamLeader(Sprint sprint, String teamLeader) async {
    await sprintRef.doc(_sprint.id).update({'teamLeader': teamLeader});
    _sprint = _sprint.copyWith(teamLeader: teamLeader);
    updateUpdatedAt(sprint);
    debugPrint('updated teamLeader DB');
    return sprint = await getSprint(sprint.id);
  }
  /// updates class _sprint potentialLeaders in database
  /// Please note that every potentialLeader stored in the list must be unique,
  /// or firestore will overwrite stored String potentialLeaders with
  /// this String potentialLeaders
  Future<Sprint> updatePotentialLeaders(Sprint sprint, String potentialLeaders) async {
    sprintRef.doc(sprint.id).update({
      "potentialLeaders": FieldValue.arrayUnion(['$potentialLeaders'])
    }).then((_) {
      debugPrint(
          'Added potentialLeaders: $potentialLeaders to sprint ${sprint.id}');
    });
    updateUpdatedAt(sprint);
    ///to get and store correct properties into class _sprint object
    return sprint = await getSprint(sprint.id);
  }

  /// updates _sprint in database
  /// Please note that every member stored in the list must be unique,
  /// or firestore will overwrite stored String member with
  /// this String member
  Future<Sprint> addMembers(Sprint sprint, String member) async {
    sprintRef.doc(sprint.id).update({
      "members": FieldValue.arrayUnion(['$member'])
    }).then((_) {
      debugPrint('Added member: $member to sprint ${sprint.id}');
    });
    updateUpdatedAt(sprint);
    ///to get and store correct properties into class _sprint object
    return sprint = await getSprint(sprint.id);
  }

  /// remove _sprint members from database
  /// Please note that every member stored in the list must be unique,
  /// or firestore will overwrite stored String member with
  /// this String member
  Future<Sprint> removeMembers(Sprint sprint, String member) async {
    sprintRef.doc(sprint.id).update({
      "members": FieldValue.arrayRemove(['$member'])
    }).then((_) {
      debugPrint('removed member: $member sprint ${sprint.id}');
    });
    updateUpdatedAt(sprint);
    ///to get and store correct properties into class _sprint object
    return sprint = await getSprint(sprint.id);
  }


  /// adds SprintPost object to _sprint in database
  /// Please note that every SprintPost stored in the list must be unique,
  /// or firestore will overwrite stored SprintPost with
  /// this SprintPost
  Future<Sprint> addPosts(Sprint sprint, SprintPost post) async {
    sprintRef.doc(sprint.id).update({
      "posts": FieldValue.arrayUnion([sprintPostToJson(post)])
    }).then((_) {
      debugPrint('Added post: $post to sprint ${sprint.id}');
    });
    updateUpdatedAt(sprint);
    ///to get and store correct properties into class _sprint object
    return sprint = await getSprint(sprint.id);
  }

  /// The idea here is to get a document ID from a Stream of multiple documents
  /// then store it to the current _sprint for use of display and updates for Sprint Services.
  ///
  /// To get the document ID to pass to this function:
  ///  1. StreamBuilder -> store as AsyncSnapshot<QuerySnapshot> snapshot using
  ///    getAllIdeasFromDBStream(), getIdeasFromDBForCurrentMonthStream(), or searchIdeasByTitle()
  ///  2. ListView -> children: snapshot.data.docs.map((document) widgets for each document)
  ///  3. access a specific sprint's details "onTapped" with this method passing "document.id"
  ///     to this method
  Future<Sprint> getSprint(String documentId) async {
    DocumentSnapshot doc;
    Sprint sprint;
    await sprintRef.doc(documentId).get().then((document) async{
      if (document.exists) {
        doc = document;
        print('Document data: ${doc.data()}');
        sprint = fromFirestore(doc);
      } else {
        print('Document does not exist on the database');
      }
    });
    print(sprint.toString());
    return sprint;
  }

  ///get all sprint documents from database,returns Instance of '_MapStream<QuerySnapshotPlatform, QuerySnapshot>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _sprintService.getAllSprintsFromDBStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getAllSprintsFromDBStream() async {
    debugPrint('getAllSprintsFromDBStream() performing...');
    return sprintRef.snapshots();
  }
  
}
