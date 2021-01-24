import 'package:idea_tracker/model/user.dart';

class AuthenticationService {
  User _signedInUser;
  User get signedInUser => _signedInUser;

  /// Sign in user
  ///
  /// Returns the [User] model if successful
  Future<User> signIn({
    String username,
    String password,
  }) async {
    _signedInUser = User(
      id: "id",
      username: "username",
    );
    return _signedInUser;
  }

  /// Sign out [_signedInUser]
  Future<void> signOut() async {
    _signedInUser = null;
  }

  /// Sign up new user
  Future<void> signUp({
    String username,
    String password,
    String confirmPassword,
  }) async {}
}
