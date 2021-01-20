import 'package:flutter_test/flutter_test.dart';

import '../lib/service/services.dart';
import '../lib/model/models.dart';

class TestServices {
  AuthenticationService _authenticationService = new AuthenticationService();
  IdeaService _ideaService = new IdeaService();
  SprintService _sprintService = new SprintService();
  UserService _userService = new UserService();

  testServices() async {
    await _authenticationService.signUp(
        "foobar@test1.com", "123qweASD#\$%", "123qweASD#\$%");
    print(
       'Authentication Sign In Test Complete...Next line should show user details for same as above');
    await new Future.delayed(const Duration(seconds: 3));
    await _authenticationService.signOut();
    await new Future.delayed(const Duration(seconds: 3));
    await _authenticationService.signIn("foobar@test.com", "123qweASD#\$%");
    print(
        'Authentication Sign In Test Complete...Next line should show user details for ZIE1S79L3CRPNn3EaR0yi3sWMOO2');
    await new Future.delayed(const Duration(seconds: 3));
    await runUserServiceTest();
    await new Future.delayed(const Duration(seconds: 3));
    await runIdeaServiceTest();
    await new Future.delayed(const Duration(seconds: 6));
    await runSprintServicesTest();
  }

  runUserServiceTest() async {
    ///existing user for testing
    ///_authenticationService.signIn("foobar@test.com", "123qweASD#\$%");
    final User _testUser = User(
        id: "ZIE1S79L3CRPNn3EaR0yi3sWMOO2",
        email: "foobar@test.com",
        userName: "foobar@test.com",
        photoURL: "_");

    await _userService.getCurrentUserDocument(_testUser);
    await _userService
        .updateUserName(_testUser.copyWith(userName: "Foo Bar Bar Bar"));
    await new Future.delayed(const Duration(seconds: 3));
    await _userService.updateUserPhotoURL(
        _testUser.copyWith(photoURL: 'new images of myself'));
    await new Future.delayed(const Duration(seconds: 3));
    await _userService.getCurrentUser();
    print(_testUser.toString());
    await new Future.delayed(const Duration(seconds: 3));
    var userStream = await _userService.getCurrentUserAsStream(_testUser);
    await new Future.delayed(const Duration(seconds: 3));
    print('getCurrentUserAsStream(): ${userStream.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
    await _userService.getCurrentUserDocument(_testUser);
  }

  ///testing all functions of this service class
  runIdeaServiceTest() async {
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

    _testIdea = await _ideaService.create(_testIdea);
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.update(_testIdea, UpdateIdea.title, 'New Idea Title');
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.update(_testIdea, UpdateIdea.title,'Updated Title');
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.update(_testIdea, UpdateIdea.title, 'Updated Title Again');
    await new Future.delayed(const Duration(seconds: 3));
    print(_testIdea.toString());
    await _ideaService.update(_testIdea, UpdateIdea.description, "New Description");
    await _ideaService.update(_testIdea, UpdateIdea.description, "Updated Description");
    await _ideaService.update(
        _testIdea, UpdateIdea.description,'Updated Description Again');
    await new Future.delayed(const Duration(seconds: 3));
    print(_testIdea.toString());
    await _ideaService.update(_testIdea1, UpdateIdea.vote,"No");
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.update(_testIdea1, UpdateIdea.vote, "Yes");
    await new Future.delayed(const Duration(seconds: 3));

    ///This next update overwrites the previous "No" string
    await _ideaService.update(_testIdea1, UpdateIdea.vote, "No");
    print('{$_testIdea.toString()}...');
    await _ideaService.delete(_testIdea);

    await _ideaService.get(_testIdea1.id);
    await new Future.delayed(const Duration(seconds: 3));
    var number = _ideaService.getAsStream(_testIdea1).toString();
    await new Future.delayed(const Duration(seconds: 3));
    print('from getCurrentIdeaFromDBAsStream(): $number');
    var titles = await _ideaService.searchByTitle('TiTle');
    print('from searchIdeasByTitle(): $titles');
    await new Future.delayed(const Duration(seconds: 3));
    var title0 = await _ideaService.getAll();
    print('from getIdeasFromDBForCurrentMonthStream(): ${title0.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
    var title1 = await _ideaService.getAllIdeas();
    print('from getAllIdeasFromDBStream(): ${title1.toString()}');
  } //end test

  runSprintServicesTest() async {
    ///Test Sprint objects
    SprintPost _post0 = new SprintPost(
        id: 0,
        title: 'Sprint Post 0',
        content: 'Content 0',
        createdAt: DateTime.now().millisecondsSinceEpoch);
    SprintPost _post1 = new SprintPost(
        id: 1,
        title: 'Sprint Post 1',
        content: 'Content 1',
        createdAt: DateTime.now().millisecondsSinceEpoch);
    SprintPost _post2 = new SprintPost(
        id: 2,
        title: 'Sprint Post 2',
        content: 'Content 2',
        createdAt: DateTime.now().millisecondsSinceEpoch);

    ///full test Sprint Objects
    Sprint _sprintTest = new Sprint(
      title: "Sprint Title",
      description: "test description",
      members: ['member0', 'member1', 'member2'],
      potentialLeaders: ['potentialLeaders0', 'potentialLeaders1'],
      teamLeader: 'teamLeader',
      createdAt: DateTime.now().microsecondsSinceEpoch,
      updatedAt: DateTime.now().microsecondsSinceEpoch,
      posts: List<SprintPost>(),
    );

    Sprint _sprintTest1 = new Sprint(
      id: 'TodjI69eQV4xwSkuQx2T',
      title: "Sprint Title",
      description: "test description",
      teamLeader: 'teamLeader',
      members: ['member0', 'member1', 'member2'],
      potentialLeaders: ['potentialLeaders0', 'potentialLeaders1'],
      createdAt: DateTime.now().microsecondsSinceEpoch,
      updatedAt: DateTime.now().microsecondsSinceEpoch,
      posts: List<SprintPost>(),
    );


    _sprintTest = await _sprintService.create(_sprintTest);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(_sprintTest1, UpdatePost.create,  _post0);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(_sprintTest1, UpdatePost.create,  _post1);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(_sprintTest1, UpdatePost.create,  _post2);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(_sprintTest, UpdateSprint.title, "Update Sprint Title");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(_sprintTest, UpdateSprint.description, "Update Sprint Description");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(_sprintTest, UpdateSprint.addMember, "member3");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(_sprintTest, UpdateSprint.teamLeader, "potentialLeader2");
    await new Future.delayed(const Duration(seconds: 3));
    print(_sprintTest.toString());
    _sprintService.delete(_sprintTest);
    await new Future.delayed(const Duration(seconds: 3));

    _sprintTest1 = await _sprintService.get("TodjI69eQV4xwSkuQx2T");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(_sprintTest1, UpdateSprint.addPotentialLeader, "added leader");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(_sprintTest1, UpdateSprint.deletePotentialLeader, _sprintTest1.potentialLeaders[2]);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(_sprintTest1, UpdatePost.create,  _post0);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(_sprintTest1, UpdatePost.create, _post1);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(_sprintTest1, UpdatePost.create, _post2);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(_sprintTest1, UpdatePost.delete, _sprintTest1.posts[1]);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(_sprintTest1, UpdateSprint.addMember, 'member4');
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(_sprintTest1, UpdateSprint.deleteMember, 'member3');
    await new Future.delayed(const Duration(seconds: 3));
  }
}
