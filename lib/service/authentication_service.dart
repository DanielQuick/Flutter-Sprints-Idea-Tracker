import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import '../locator.dart';
import '../model/user.dart';
import 'services.dart';

class AuthenticationService {
  ///create variable instances for use with Firebase
  auth.FirebaseAuth _auth;
  UserService _userService;

  ///this initializes the class variables
  initialize() {
    _auth = auth.FirebaseAuth.instance;
    _userService  = locator<UserService>();
  }

  ///Sign up with email/password
  Future<String> signUp(
      String email, String password, String passwordVerify) async {
    if (password == passwordVerify) {
      try {
        auth.UserCredential credential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print('${credential.user.metadata}');
        User user = (User(
            id: credential.user.uid,
            email: email,
            userName: email,
            photoURL: '_'));
        _userService.getUser(user);
        print('credential: ${credential.user.uid}');
        debugPrint('Signed Up');
        return 'Signed Up';
      } on auth.FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          debugPrint('The password provided is too weak.');
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          debugPrint('The account already exists for that email.');
          return 'The account already exists for that email.';
        } else {
          debugPrint('Something went wrong, please try again.');
          return 'Something went wrong, please try again.';
        }
      } catch (e) {
        print(e);
      }
    }
    return 'Passwords do not Match';
  }

  ///Sign in user with e-mail
  Future<String> signIn(String email, String password) async {
    try {
      auth.UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await new Future.delayed(const Duration(microseconds: 5));
      User user = (User(
          id: credential.user.uid,
          email: email,
          userName: email,
          photoURL: '_'));
      print('credential: ${credential.user.uid}');
      _userService.getUser(user);
      await new Future.delayed(const Duration(microseconds: 5));
      debugPrint('Signed In');
      return 'Signed In';
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        return 'The account already exists for that email.';
      } else {
        debugPrint('Something went wrong, please try again.');
        return 'Something went wrong, please try again.';
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///sign out
  Future<void> signOut() async {
    await _auth.signOut();
    debugPrint('Signed Out');
  }

  ///returns the current authenticated user as User object
  User authenticatedUser() {
    User _authenticatedUser;
      auth.User user = _auth.currentUser;
      if (user == null) {
        _authenticatedUser = null;
        print('User is currently signed out!');
        return _authenticatedUser;
      } else {
        _authenticatedUser = User(
            id: user.uid,);
        new Future.delayed(const Duration(microseconds: 20));
        _authenticatedUser = _userService.getUser(_authenticatedUser);
        print('2. User from _authenticatedUser function: '+ _authenticatedUser.toString());
        print('User is signed in!');
        return _authenticatedUser;
      }
  }

  ///return
  bool isSignedIn(){
    auth.User user = _auth.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  ///password verification
  bool verifyPassword(String password, String passwordVerify) {
    if (password == passwordVerify) {
      return true;
    } else {
      return false;
    }
  }

  ///enables send user a password reset by e-mail...Link to forgot password logic
  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  ///enable a change password from within app
  Future<String> changePassword(String password, String passwordVerify) async {
    ///Create an instance of the current user.
    auth.User user = _auth.currentUser;
    if (password == passwordVerify) {
      ///Pass in the password to updatePassword.
      user.updatePassword(password).then((_) {
        debugPrint('Your password changed Successfully!');
        return 'Your password changed Successfully!';
      }).catchError((err) {
        ///This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        debugPrint("You can't change the Password" + err.toString());
        return "You can't change the Password" + err.toString();
      });
    } else {
      debugPrint('Your passwords do not match, please try again.');
      return 'Your passwords do not match, please try again.';
    }
    return null;
  }
}
