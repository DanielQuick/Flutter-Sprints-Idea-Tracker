import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:idea_tracker/model/user.dart';
import 'package:idea_tracker/service/services.dart';


class AuthenticationService {
  UserService _userService = new UserService();
  User user = new User();

  signUp(String email, pwd, pwdVerify){
    _userService.setCurrentUser(user.copyWith(id: "AutoIdByFirebaseAuth", email: email, userName: email));
    debugPrint('$email is the current user, all userService functions will be taken against this user');
    return 'success';
  }

  signOut(){
    return 'success';
  }

  signIn(String email, pwd){
    debugPrint('$email is the current user, all userService functions will be taken against this user');
    return 'success';
  }
}