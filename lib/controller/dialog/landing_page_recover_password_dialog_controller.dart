import 'package:flutter/foundation.dart';

enum RecoverPasswordStatus { initial, waiting, success, failed }

class LandingPageRecoverPasswordDialogController extends ChangeNotifier {
  String _email;
  RecoverPasswordStatus status = RecoverPasswordStatus.initial;

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

  void resetPassword() async {
    print("Reseting password for $_email");

    status = RecoverPasswordStatus.waiting;
    notifyListeners();

    // TODO: reset password throught AuthenticationService
    final success = await Future.delayed(
      Duration(milliseconds: 5000),
      () => true,
    );

    if (success) {
      status = RecoverPasswordStatus.success;
    } else {
      status = RecoverPasswordStatus.failed;
    }

    notifyListeners();
  }
}
