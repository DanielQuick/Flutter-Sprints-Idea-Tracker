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

  Idea _testIdea = new Idea(
    description: 'Test description',
    title: 'Test title',
  );

  ///This is the Idea used for testing with minimal input for operation within firestore
  ///it already exists
  Idea _testIdea1 = new Idea(
    id: 'c49yHUU9uXSZeVYZN5iN',
    description: 'Test c49yHUU9uXSZeVYZN5iN description',
    title: 'Test c49yHUU9uXSZeVYZN5iN title',
  );

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

  ///used to input the idea into the database.
  ///This is only used the first time an idea is input into the database
  toJson(String id) {
    return {
      "id": id,
      "title": _idea.title,
      "titleArray":
          _idea.title.toLowerCase().split(new RegExp('\\s+')).toList(),
      "description": _idea.description,
      "createdAt": _idea.createdAt ?? currentTimeInSeconds(),
      "updatedAt": _idea.updatedAt ?? currentTimeInSeconds(),
      "votes": _idea.votes ?? new List<String>(),
    };
  }

  /// print the current stored idea to a string for debugging purposes
  ideaToString() {
    return 'Idea: id: ${_idea.id}, '
        'title: ${_idea.title}, '
        'description: ${_idea.description}, '
        'createdAt: ${_idea.createdAt}, '
        'updatedAt: ${_idea.updatedAt}, '
        'votes: ${_idea.votes}';
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
  Future<void> addToDB() async {
    DocumentReference docReference = ideaRef.doc();
    await ideaRef.doc(docReference.id).set(toJson(docReference.id));
    _idea = _idea.copyWith(
        id: docReference.id, createdAt: currentTimeInSeconds());
    debugPrint('Added idea id: ${_idea.id} to DB');
  }

  /// removes _idea from the database
  Future<void> removeFromDB() async {
    await ideaRef.doc(_idea.id).delete();
    debugPrint('removed idea ${_idea.id} from DB');
    _idea = null;
  }

  /// updates _idea title and searchable title array in the database and updates _idea with that title
  Future<void> updateTitle(String title) async {
    await ideaRef
        .doc(_idea.id)
        .update({'title': title})
        .then((value) => print("Title Updated for ${_idea.id}"))
        .catchError((error) => print("Failed to update title for ${_idea.id}: $error"));
    await ideaRef
        .doc(_idea.id)
        .update({
          "titleArray": title.toLowerCase().split(new RegExp('\\s+')).toList()
        })
        .then((value) => print("Title Array ${_idea.id}"))
        .catchError((error) => print("Failed to update ${_idea.id} titleArray: $error"));
    _idea = _idea.copyWith(title: title);
    updateUpdatedAt();
    debugPrint('updated idea ${_idea.id} title in DB');
  }

  /// updates _idea description in the database and updates _idea with that description
  Future<void> updateDescription(String description) async {
    await ideaRef
        .doc(_idea.id)
        .update({'description': description})
        .then((value) => print("description Updated for ${_idea.id}"))
        .catchError((error) => print("Failed to update description: $error"));
    _idea = _idea.copyWith(description: description);
    updateUpdatedAt();
  }

  /// updates _idea udpatedAt in the database and updates _idea with that update
  /// is called when each field is updated
  Future<void> updateUpdatedAt() async {
    await ideaRef.doc(_idea.id).update(
        {'updatedAt': DateTime.now().microsecondsSinceEpoch});
    _idea = _idea.copyWith(updatedAt: DateTime.now().microsecondsSinceEpoch);
    debugPrint('updated idea ${_idea.id} updatedAt DB');
  }

  /// updates _idea in the database and udpates _idea with that update
  /// Please note that every vote stored in the list must be unique,
  /// or firestore will overwrite stored String vote with
  /// this String vote
  Future<void> updateVotes(String vote) async {
    await ideaRef.doc(_idea.id).update({
      "votes": FieldValue.arrayUnion([vote])}).then((_) {
      updateUpdatedAt();
      debugPrint('Added votes: $vote to idea ${_idea.id}');
    });
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
  Future<DocumentSnapshot> getIdeaFromDBDocument(String documentId) async {
    DocumentSnapshot doc;
    await ideaRef.doc(documentId).get().then((document) {
      if (document.exists) {
        doc = document;
        print('Document data: ${doc.data()}');
        _idea = fromFirestore(doc);
      } else {
        print('Document does not exist on the database');
      }
    });
    ideaToString();
    return doc;
  }

  ///get _idea as a stream, returns Instance of '_MapStream<DocumentSnapshot, String>'
  ///suggested use:
  ///           StreamBuilder(
  ///             stream: _ideaService.getIdeasFromDBForCurrentMonthStream(),
  ///             builder:
  ///                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  ///                 ...
  ///                 },)
  getCurrentIdeaFromDBAsStream() async {
    debugPrint('getCurrentIdeaFromDBStream() performing...');
    return ideaRef.doc(_idea.id).get().asStream();
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

  ///testing all functions of this service class
  runIdeaServiceTest() async {
    setCurrentIdea(_testIdea1);
    getCurrentIdea();
    print(ideaToString());
    //await addToDB();
    await new Future.delayed(const Duration(seconds: 3));
    print(ideaToString());
    //await updateTitle('New Idea Title');
    //await new Future.delayed(const Duration(seconds: 3));
    //await updateTitle('Updated Title');
    //await new Future.delayed(const Duration(seconds: 3));
    //await updateTitle('Updated Title Again');
    //await new Future.delayed(const Duration(seconds: 3));
    //print(ideaToString());
    //await updateDescription("New Description");
    //await updateDescription("Updated Description");
    //await updateDescription('Updated Description Again');
    //await new Future.delayed(const Duration(seconds: 3));
    //print(ideaToString());
    //await updateVotes("No");
    //await new Future.delayed(const Duration(seconds: 3));
    //await updateVotes("Yes");
    //await new Future.delayed(const Duration(seconds: 3));
    ///This next update overwrites the previous "No" string
    //await updateVotes("No");
    //await new Future.delayed(const Duration(seconds: 3));
    //print(ideaToString());

    await setCurrentIdea(_testIdea);
    print(ideaToString());
    await getIdeaFromDBDocument(_testIdea1.id);
    print(ideaToString());
    await new Future.delayed(const Duration(seconds: 3));
    Stream<DocumentSnapshot> streamedCurrentIdea =
        await getCurrentIdeaFromDBAsStream();
    int number = await streamedCurrentIdea.length;
    await new Future.delayed(const Duration(seconds: 3));
    print('from getCurrentIdeaFromDBAsStream(): $number');
    var titles = await searchIdeasByTitle('TiTle');
    print('from searchIdeasByTitle(): $titles');
    await new Future.delayed(const Duration(seconds: 3));
    var title0 =  await getIdeasFromDBForCurrentMonthStream();
    print('from getIdeasFromDBForCurrentMonthStream(): ${title0.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
    var title1 = await getAllIdeasFromDBStream();
    print('from getAllIdeasFromDBStream(): ${title1.toString()}');

  } //end test
}
