import 'package:idea_tracker/model/user.dart';

class UserService {
  /// Get User with [id]
  Future<User> get({String id}) async {
    return User(
      id: "id",
      username: "username",
    );
  }
}
