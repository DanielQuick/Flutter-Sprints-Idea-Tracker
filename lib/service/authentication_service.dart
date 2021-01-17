import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import '../model/user.dart';
import 'user_service.dart';

class AuthenticationService {
  ///create variable instances for use with Firebase
  auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  UserService _userService = new UserService();

  ///Sign up with email/password
  Future<String> signUp(
      String email, String password, String passwordVerify) async {
    if (password == passwordVerify) {
      try {
        auth.UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print('${credential.user.metadata}');
        await _userService.setCurrentUser(User(id: credential.user.uid, email: email, userName: email, photoURL: '_'));
        //await _userService.addToDB(credential.user.uid);
        await new Future.delayed(const Duration(microseconds: 5));
        print('${credential.user.metadata}');
        await _userService.getCurrentUserDocument();
        debugPrint(_userService.userToString());
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
      await _userService.setCurrentUser(User(id: credential.user.uid, email: email, userName: email, photoURL: '_'));
      await new Future.delayed(const Duration(microseconds: 5));
      print('${credential.user.metadata}');
      await _userService.getCurrentUserDocument();
      print("authentication sign in: " + _userService.userToString());
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

  ///password verification
  bool verifyPassword(String password, String passwordVerify) {
    if (password == passwordVerify) {
      return true;
    } else {
      return false;
    }
  }
}
