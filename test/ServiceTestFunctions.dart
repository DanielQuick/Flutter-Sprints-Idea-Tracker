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
    await new Future.delayed(const Duration(seconds: 3));
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

    _ideaService.setCurrentIdea(_testIdea1);
    _ideaService.getCurrentIdea();
    print(_testIdea1.toString());
    //await _ideaService.add(_testIdea);
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.updateTitle(_testIdea1, 'New Idea Title');
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.updateTitle(_testIdea1, 'Updated Title');
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.updateTitle(_testIdea1, 'Updated Title Again');
    await new Future.delayed(const Duration(seconds: 3));
    print(_testIdea1.toString());
    await _ideaService.updateDescription(_testIdea1, "New Description");
    await _ideaService.updateDescription(_testIdea1, "Updated Description");
    await _ideaService.updateDescription(_testIdea1, 'Updated Description Again');
    await new Future.delayed(const Duration(seconds: 3));
    print(_testIdea1.toString());
    await _ideaService.updateVotes(_testIdea1, "No");
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.updateVotes(_testIdea1, "Yes");
    await new Future.delayed(const Duration(seconds: 3));
    ///This next update overwrites the previous "No" string
    await _ideaService.updateVotes(_testIdea1, "No");
    await new Future.delayed(const Duration(seconds: 3));
    await _ideaService.setCurrentIdea(_testIdea);
    print(_testIdea.toString());
    await _ideaService.getIdeaFromDBDocument(_testIdea1.id);
    await new Future.delayed(const Duration(seconds: 3));
    int number = await _ideaService.geIdeaAsStream(_testIdea1);
    await new Future.delayed(const Duration(seconds: 3));
    print('from getCurrentIdeaFromDBAsStream(): $number');
    var titles = await _ideaService.searchIdeasByTitle('TiTle');
    print('from searchIdeasByTitle(): $titles');
    await new Future.delayed(const Duration(seconds: 3));
    var title0 =  await _ideaService.getIdeasFromDBForCurrentMonthStream();
    print('from getIdeasFromDBForCurrentMonthStream(): ${title0.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
    var title1 = await _ideaService.getAllIdeasFromDBStream();
    print('from getAllIdeasFromDBStream(): ${title1.toString()}');

  } //end test

  runSprintServicesTest() async{
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


      _sprintService.setCurrentSprint(_sprintTest);
      await _sprintService.add(_sprintTest);
      await new Future.delayed(const Duration(seconds: 3));
      _sprintTest = await _sprintService.addPosts(_sprintTest, _post0);
      _sprintTest = await _sprintService.addPosts(_sprintTest, _post1);
      _sprintTest = await _sprintService.addPosts(_sprintTest, _post2);
      await new Future.delayed(const Duration(seconds: 3));
      _sprintTest = await _sprintService.updateTitle(_sprintTest, "Update Sprint Title");
      await new Future.delayed(const Duration(seconds: 3));
      _sprintTest = await _sprintService.updateDescription(_sprintTest, "Update Sprint Description");
      await new Future.delayed(const Duration(seconds: 3));
      _sprintTest = await _sprintService.addMembers (_sprintTest, "member3");
      await new Future.delayed(const Duration(seconds: 3));
      _sprintTest = await _sprintService.updatePotentialLeaders (_sprintTest, "potentialLeader2");
      await new Future.delayed(const Duration(seconds: 3));
      print(_sprintTest.toString());
      await _sprintService.getSprint("KI746fvW68f4pG5p9DrR");
      ///works for stored class _sprint
      _sprintService.deleteFromDB(_sprintTest);
      _sprintService.setCurrentSprint(_sprintTest1);
      await new Future.delayed(const Duration(seconds: 3));
      await _sprintService.addPosts(_sprintTest1, _post0);
      await _sprintService.addPosts(_sprintTest1, _post1);
      await _sprintService.addPosts(_sprintTest1, _post2);
      await new Future.delayed(const Duration(seconds: 3));
      await _sprintService.addMembers(_sprintTest1, 'member4');
      await new Future.delayed(const Duration(seconds: 3));
      await _sprintService.removeMembers(_sprintTest1, 'member0');
      await new Future.delayed(const Duration(seconds: 3));
      print(_sprintTest1.toString());

  }
}
