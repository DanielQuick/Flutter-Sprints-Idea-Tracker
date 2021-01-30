import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:idea_tracker/model/user.dart';
import '../locator.dart';
import 'services.dart';

class AuthenticationService {
  ///create variable instances for use with Firebase
  auth.FirebaseAuth _auth;
  UserService _userService;
  User _authenticatedUser;

  ///this initializes the class variables
  initialize() {
    _auth = auth.FirebaseAuth.instance;
    _userService = locator<UserService>();
  }

  ///Sign up with email/password
  Future<String> signUp(String email, String userName, String password,
      String passwordVerify) async {
    if (password == passwordVerify) {
      try {
        auth.UserCredential credential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((credential) async {
          User user0 = (User(
              id: credential.user.uid,
              email: email,
              userName: userName,
              photoURL: '_'));
          await _userService.setAuthenticatedUserFromFirestore(user0).then(
              (snapshot) => _authenticatedUser = User(
                  id: snapshot.data()["id"],
                  userName: snapshot.data()["userName"],
                  email: snapshot.data()["email"],
                  photoURL: snapshot.data()["photoURL"]));
          return credential;
        });
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
      auth.UserCredential credential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((credential) async {
        User user0 = (User(
            id: credential.user.uid,
            email: email,
            userName: email,
            photoURL: '_'));
        await _userService.setAuthenticatedUserFromFirestore(user0).then(
            (snapshot) => _authenticatedUser = User(
                id: snapshot.data()["id"],
                userName: snapshot.data()["userName"],
                email: snapshot.data()["email"],
                photoURL: snapshot.data()["photoURL"]));
        return credential;
      });
      await new Future.delayed(const Duration(microseconds: 5));
      print('credential: ${credential.user.uid}');
      await new Future.delayed(const Duration(microseconds: 5));
      debugPrint('Signed In');
      return 'Signed In';
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        debugPrint('Something went wrong, please try again.');
        return 'Something went wrong, please try again.' + e.message;
      }
    } catch (e) {
      debugPrint('Something went wrong, please try again.');
      print(e);
      return 'Something went wrong, please try again.';
    }
  }

  ///sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _authenticatedUser = null;
    debugPrint('Signed Out');
  }

  ///returns the current authenticated user as User object
  Future<User> authenticatedUser() async {
    if (_auth.currentUser == null) {
      _authenticatedUser = null;
      print('User is currently signed out!');
      return _authenticatedUser;
    } else {
      _authenticatedUser =
          await _userService.get(_auth.currentUser.uid).then((user) {
        debugPrint('authenticatedUser() ' + _authenticatedUser.toString());
        return user;
      });
      print('User is signed in!');
      return _authenticatedUser;
    }
  }

  User getAuthenticatedUser() {
    return this._authenticatedUser;
  }

  ///return
  bool isSignedIn() {
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
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      }
    } catch (e) {
      debugPrint('Something went wrong, please try again.');
      print(e);
      return 'Something went wrong, please try again.';
    }
  }

  /// this enables a change password from within app and always returns a string
  /// if passwords supplied match and the change goes through: 'Your password changed Successfully!'
  /// if there is an error: "You can't change the Password" + err.toString()
  /// if the passwords do not match: 'Your passwords do not match, please try again.'
  /// await locator<AuthenticationService>().changePassword(String password, String passwordVerify)
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
