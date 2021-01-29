import 'package:flutter/foundation.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/service/authentication_service.dart';

class LandingPageRecoverPasswordDialogController extends ChangeNotifier {
  String _email;
  String _message;
  bool requestSubmited = false;

  final _authService = locator<AuthenticationService>();

  String get message => _message;

  void setEmail(String value) {
    _email = value;
  }

  String validateEmail(String value) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

    if (value.isEmpty) {
      return "Please, enter email";
    } else if (RegExp(emailRegex).hasMatch(value)) {
      return null;
    } else {
      return "Invalid email";
    }
  }

  void retry() {
    requestSubmited = false;
    notifyListeners();
  }

  void resetPassword() async {
    _message = await _authService.forgotPassword(_email);
    requestSubmited = true;
    notifyListeners();
  }
}
