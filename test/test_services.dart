import 'package:flutter_test/flutter_test.dart';
import '../lib/locator.dart';
import '../lib/service/services.dart';
import '../lib/model/models.dart';

class TestServices {
  UserService _userService = locator<UserService>();
  IdeaService _ideaService = locator<IdeaService>();
  SprintService _sprintService = locator<SprintService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  User user;

  testServices() async {
    bool isSignedIn;
    //User user = _authenticationService.authenticatedUser();
    //print(user.toString());
    await _authenticationService.signUp("test@user.com", "Test User", "testUser123", "testUser123");
    //await new Future.delayed(const Duration(seconds: 3));
    //await _authenticationService.signOut();
    isSignedIn = _authenticationService.isSignedIn();
    print(isSignedIn);
    await new Future.delayed(const Duration(seconds: 3));
    //await _authenticationService.forgotPassword('fluttersprints@gmail.com');
    await new Future.delayed(const Duration(seconds: 3));
    isSignedIn = _authenticationService.isSignedIn();
    print(isSignedIn);
    //await _authenticationService.signIn("test@user.com", "testUser123");
    isSignedIn = _authenticationService.isSignedIn();
    print(isSignedIn);
    await new Future.delayed(const Duration(seconds: 3));
    user = _authenticationService.authenticatedUser();
    await new Future.delayed(const Duration(seconds: 3));
    print('User from Test file auth test: '+user.toString());
    // print(
    //'Authentication Sign In Test Complete...Next line should show user details
    // for ZIE1S79L3CRPNn3EaR0yi3sWMOO2');
    await new Future.delayed(const Duration(seconds: 3));
    //await runUserServiceTest();
    await new Future.delayed(const Duration(seconds: 3));
    await runIdeaServiceTest();
    await new Future.delayed(const Duration(seconds: 6));
    await runSprintServicesTest();
  }

  runUserServiceTest() async {
    ///existing user for testing
    ///_authenticationService.signIn("foobar@test.com", "123qweASD#\$%");
    User _testUser = User(
        id: "ZIE1S79L3CRPNn3EaR0yi3sWMOO2",
        email: "foobar@test.com",
        userName: "foobar@test.com",
        photoURL: "_");

    _userService.getUser(_testUser);
    _testUser = _userService.getUser(_testUser);
    await _userService
        .update(_testUser,UpdateUser.userName, 'foo bar');
    await new Future.delayed(const Duration(seconds: 3));
    await _userService.update(
        _testUser, UpdateUser.photo, 'some url to a photo');
    await new Future.delayed(const Duration(seconds: 3));
    _testUser = _userService.getUser(_testUser);
    print(_testUser.toString());
    await new Future.delayed(const Duration(seconds: 3));
    var userStream = await _userService.getCurrentUserAsStream(_testUser);
    await new Future.delayed(const Duration(seconds: 3));
    print('getCurrentUserAsStream(): ${userStream.toString()}');
    await new Future.delayed(const Duration(seconds: 3));
  }

  ///testing all functions of this service class
  runIdeaServiceTest() async {
    Idea _testIdea = new Idea(
      description: 'Test description',
      title: 'Test title',
    );

    ///This is the Idea used for testing with minimal input for operation within
    /// firestore it already exists
    /*
    Idea _testIdea1 = new Idea(id: 'hqw103o7xuRJ8ObUYijZ');

    _testIdea = await _ideaService.create(_testIdea);
    //_testIdea = await _ideaService.get(_testIdea.id);
    await new Future.delayed(const Duration(seconds: 3));
    _testIdea = await _ideaService.update(
        _testIdea, UpdateIdea.title, 'New Idea Title');
    await new Future.delayed(const Duration(seconds: 3));
    _testIdea =
        await _ideaService.update(_testIdea, UpdateIdea.title, 'Updated Title');
    await new Future.delayed(const Duration(seconds: 3));
    _testIdea = await _ideaService.update(
        _testIdea, UpdateIdea.title, 'Updated Title Again');
    await new Future.delayed(const Duration(seconds: 3));
    print(_testIdea.toString());
    await new Future.delayed(const Duration(seconds: 3));
    _testIdea = await _ideaService.update(
        _testIdea, UpdateIdea.description, "New Description");
    await new Future.delayed(const Duration(seconds: 3));
    _testIdea = await _ideaService.update(
        _testIdea, UpdateIdea.description, "Updated Description");
    await new Future.delayed(const Duration(seconds: 3));
    _testIdea = await _ideaService.update(
        _testIdea, UpdateIdea.description, 'Updated Description Again');
    await new Future.delayed(const Duration(seconds: 3));
    print(_testIdea.toString());
    _testIdea = await _ideaService.update(_testIdea, UpdateIdea.vote, "Yes");
    await new Future.delayed(const Duration(seconds: 3));

    ///shouldn't let vote go through user already voted this idea
    _testIdea = await _ideaService.update(_testIdea, UpdateIdea.vote, "No");
    await new Future.delayed(const Duration(seconds: 3));

    ///shouldn't let vote go through user already voted this idea
    _testIdea = await _ideaService.update(_testIdea, UpdateIdea.vote, "No");
    print('{Should have 1 yes and 0 No:  ${_testIdea.toString()}...');
    await _ideaService.delete(_testIdea);

    _testIdea1 = await _ideaService.get(_testIdea1.id);

    //_testIdea = await _ideaService.get(_testIdea.id);
    await new Future.delayed(const Duration(seconds: 3));
    var number = _ideaService.getAsStream(_testIdea).toString();
    await new Future.delayed(const Duration(seconds: 3));
    print('from getCurrentIdeaFromDBAsStream(): $number');
    var titles = await _ideaService.searchByTitle('TiTle');
    print('from searchIdeasByTitle(): $titles');
    await new Future.delayed(const Duration(seconds: 3));

     */
    var title0 = await _ideaService.getAll();
    print('from getAll(): $title0');
    await new Future.delayed(const Duration(seconds: 3));
   // var title1 = await _ideaService.getAllIdeas();
    //print('from getAllIdeasFromDBStream(): ${title1.toString()}');
  } //end test

  runSprintServicesTest() async {
    /*
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
    _sprintTest1 = await _sprintService.updatePost(
        _sprintTest1, UpdatePost.create, _post0);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(
        _sprintTest1, UpdatePost.create, _post1);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(
        _sprintTest1, UpdatePost.create, _post2);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(
        _sprintTest, UpdateSprint.title, "Update Sprint Title");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(
        _sprintTest, UpdateSprint.description, "Update Sprint Description");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(
        _sprintTest, UpdateSprint.addMember, "member3");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest = await _sprintService.update(
        _sprintTest, UpdateSprint.teamLeader, "potentialLeader2");
    await new Future.delayed(const Duration(seconds: 3));
    print(_sprintTest.toString());
    _sprintService.delete(_sprintTest);
    await new Future.delayed(const Duration(seconds: 3));

    _sprintTest1 = await _sprintService.get("TodjI69eQV4xwSkuQx2T");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(
        _sprintTest1, UpdateSprint.addPotentialLeader, "added leader");
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(_sprintTest1,
        UpdateSprint.deletePotentialLeader, _sprintTest1.potentialLeaders[2]);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(
        _sprintTest1, UpdatePost.create, _post0);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(
        _sprintTest1, UpdatePost.create, _post1);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(
        _sprintTest1, UpdatePost.create, _post2);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.updatePost(
        _sprintTest1, UpdatePost.delete, _sprintTest1.posts[1]);
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(
        _sprintTest1, UpdateSprint.addMember, 'member4');
    await new Future.delayed(const Duration(seconds: 3));
    _sprintTest1 = await _sprintService.update(
        _sprintTest1, UpdateSprint.deleteMember, 'member4');
    await new Future.delayed(const Duration(seconds: 3));
     */
    var title0 = await _sprintService.getAll();
    print('Sprint from getAll(): $title0');
  }
}
