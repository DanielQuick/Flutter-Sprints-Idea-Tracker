import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/sprint.dart';

class SprintService {
  ///create variable instances for use
  final sprintRef = FirebaseFirestore.instance.collection("sprints");
  Sprint _sprint = new Sprint();


  ///Test Sprint objects
  SprintPost _post0 = new SprintPost(
      id: 0,
      title: 'Sprint Post 0',
      content: 'Content 0',
      createdAt: DateTime.now().microsecondsSinceEpoch);
  SprintPost _post1 = new SprintPost(
      id: 1,
      title: 'Sprint Post 1',
      content: 'Content 1',
      createdAt: DateTime.now().microsecondsSinceEpoch);
  SprintPost _post2 = new SprintPost(
      id: 2,
      title: 'Sprint Post 2',
      content: 'Content 2',
      createdAt: DateTime.now().microsecondsSinceEpoch);

  ///full test Sprint Objects
  Sprint _sprintTest = new Sprint(
    title: "Sprint Title",
    description: "test description",
    members: ['member0', 'member1', 'member2'],
    potentialLeaders: ['potentialLeaders0', 'potentialLeaders1'],
    createdAt: DateTime.now().microsecondsSinceEpoch,
    updatedAt: DateTime.now().microsecondsSinceEpoch,
    posts: List<SprintPost>(),
  );
  Sprint _sprintTest1 = new Sprint(
    id: 'TodjI69eQV4xwSkuQx2T',
    title: "Sprint Title",
    description: "test description",
    members: ['member0', 'member1', 'member2'],
    potentialLeaders: ['potentialLeaders0', 'potentialLeaders1'],
    createdAt: DateTime.now().microsecondsSinceEpoch,
    updatedAt: DateTime.now().microsecondsSinceEpoch,
    posts: List<SprintPost>(),
  );

  ///Create Sprint object from a Firestore DocumentSnapshot
  fromFirestore(DocumentSnapshot doc) {
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
  sprintToJson(String id) {
    return {
      'id': _sprint.id ?? id,
      "title": _sprint.title,
      "titleArray":
          _sprint.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": _sprint.description,
      "createdAt": DateTime.now().microsecondsSinceEpoch,
      "updatedAt": _sprint.updatedAt,
      "potentialLeaders": _sprint.potentialLeaders ?? new List<String>(),
      "members": _sprint.members ?? new List<String>(),
      "posts": new List<SprintPost>(),
    };
  }

  ///Convert a Sprint object to string for debug purposes
  sprintToString() {
    print('Sprint: id: ${_sprint.id}, '
        'title: ${_sprint.title}, '
        'description: ${_sprint.description}, '
        'createdAt: ${_sprint.createdAt}, '
        'updatedAt: ${_sprint.updatedAt}, '
        'members: ${_sprint.members}, '
        'potentialLeaders: ${_sprint.potentialLeaders}, '
        'posts: ');
    _sprint.posts.forEach((sprintPost) => print(
        'SprintPost: ${sprintPost.id}, ${sprintPost.title}, '
            '${sprintPost.content}, ${sprintPost.createdAt}'));
  }

  ///returns int for updateUpdatedAt();
  getUpdatedAt() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  ///Sets Sprint _sprint for this class usage
  Future setCurrentSprint(Sprint sprint) async {
    this._sprint = sprint;
    debugPrint('Added ${sprint.id} as current sprint');
  }
  
  ///returns current sprint
  Future<Sprint> getCurrentSprint() async {
    return _sprint;
  }

  ///adds Sprint _sprint to the database
  Future<void> addToDB() async {
    DocumentReference docReference = sprintRef.doc();
    _sprint = _sprint.copyWith(id: docReference.id);
    await sprintRef.doc(docReference.id).set(sprintToJson(docReference.id));
    debugPrint('Added sprint id: ${_sprint.id} to DB');
  }

  ///removes/deletes class Sprint _sprint from the database
  Future<void> deleteFromDB() async {
    await sprintRef.doc(_sprint.id).delete();
    debugPrint('removed Sprint ${_sprint.id} from DB');
  }
  /// updates class _sprint title in database
  Future<void> updateTitle(String title) async {
    await sprintRef.doc(_sprint.id).update({'title': title});
    await sprintRef.doc(_sprint.id).update({"titleArray":
    title.toLowerCase().split(new RegExp('\\s+')).toList()});
    await updateUpdatedAt();
    debugPrint('updated sprint ${_sprint.id} title in DB');
  }

  /// updates class _sprint description in database
  Future<void> updateDescription(String description) async {
    await sprintRef.doc(_sprint.id).update({'description': description});
    _sprint = _sprint.copyWith(description: description);
    await updateUpdatedAt();
    debugPrint('updated description DB');
  }

  /// updates class _sprint updatedAt in database
  Future<void> updateUpdatedAt() async {
    await sprintRef.doc(_sprint.id).update({'updatedAt': getUpdatedAt()});
    _sprint = _sprint.copyWith(updatedAt: getUpdatedAt());
    debugPrint('updated updatedAt DB');
  }

  /// updates class _sprint updateTeamLeader in database
  Future<void> updateTeamLeader(String teamLeader) async {
    await sprintRef.doc(_sprint.id).update({'teamLeader': teamLeader});
    _sprint = _sprint.copyWith(teamLeader: teamLeader);
    updateUpdatedAt();
    debugPrint('updated teamLeader DB');
  }
  /// updates class _sprint potentialLeaders in database
  /// Please note that every potentialLeader stored in the list must be unique,
  /// or firestore will overwrite stored String potentialLeaders with
  /// this String potentialLeaders
  Future<void> updatePotentialLeaders(String potentialLeaders) async {
    sprintRef.doc(_sprint.id).update({
      "potentialLeaders": FieldValue.arrayUnion(['$potentialLeaders'])
    }).then((_) {
      debugPrint(
          'Added potentialLeaders: $potentialLeaders to sprint ${_sprint.id}');
    });
    updateUpdatedAt();
    ///to get and store correct properties into class _sprint object
    getSprintFromDBDocument(_sprint.id);
  }

  /// updates _sprint in database
  /// Please note that every member stored in the list must be unique,
  /// or firestore will overwrite stored String member with
  /// this String member
  Future<void> updateMembers(String member) async {
    sprintRef.doc(_sprint.id).update({
      "members": FieldValue.arrayUnion(['$member'])
    }).then((_) {
      debugPrint('Added member: $member to sprint ${_sprint.id}');
    });
    updateUpdatedAt();
    ///to get and store correct properties into class _sprint object
    getSprintFromDBDocument(_sprint.id);
  }

  /// adds SprintPost object to _sprint in database
  /// Please note that every SprintPost stored in the list must be unique,
  /// or firestore will overwrite stored SprintPost with
  /// this SprintPost
  Future<void> updatePosts(SprintPost post) async {
    sprintRef.doc(_sprint.id).update({
      "posts": FieldValue.arrayUnion([sprintPostToJson(post)])
    }).then((_) {
      debugPrint('Added post: $post to sprint ${_sprint.id}');
    });
    updateUpdatedAt();
    ///to get and store correct properties into class _sprint object
    getSprintFromDBDocument(_sprint.id);
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
  Future<DocumentSnapshot> getSprintFromDBDocument(String documentId) async {
    DocumentSnapshot doc;
    await sprintRef.doc(documentId).get().then((document) {
      if (document.exists) {
        doc = document;
        print('Document data: ${doc.data()}');
        setCurrentSprint(fromFirestore(doc));
      } else {
        print('Document does not exist on the database');
      }
    });
    sprintToString();
    return doc;
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

  runSprintServicesTest() async {
    setCurrentSprint(_sprintTest);
    await addToDB();
    await new Future.delayed(const Duration(seconds: 3));
    updatePosts(_post0);
    updatePosts(_post1);
    updatePosts(_post2);
    await new Future.delayed(const Duration(seconds: 3));
    updateTitle("Update Sprint Title");
    await new Future.delayed(const Duration(seconds: 3));
    updateDescription("Update Sprint Description");
    await new Future.delayed(const Duration(seconds: 3));
    updateMembers ("member3");
    await new Future.delayed(const Duration(seconds: 3));
    updatePotentialLeaders ("potentialLeader2");
    getSprintFromDBDocument("KI746fvW68f4pG5p9DrR");
    ///works for stored class _sprint
    //deleteFromDB();
    getSprintFromDBDocument(_sprint.id);
    await new Future.delayed(const Duration(seconds: 3));
    updatePosts(_post0);
    updatePosts(_post1);
    updatePosts(_post2);
  }
}
