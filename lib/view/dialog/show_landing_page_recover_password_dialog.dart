import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/dialog/landing_page_recover_password_dialog_controller.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

Future showLandingPageRecoverPasswordDialog({
  @required BuildContext context,
  @required String title,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return BaseView<LandingPageRecoverPasswordDialogController>(
        builder: (context, controller, child) {
          Widget alertDialogContent;

          if (controller.requestSubmited) {
            alertDialogContent = _alertContentFinish(
              context: context,
              controller: controller,
            );
          } else {
            alertDialogContent = _alertContentInitial(
              context: context,
              controller: controller,
            );
          }

          return AlertDialog(
            title: Center(child: Text(title)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
            ),
            titlePadding: const EdgeInsets.symmetric(vertical: 16),
            contentPadding: const EdgeInsets.only(
              top: 16,
              right: 20,
              left: 20,
              bottom: 10,
            ),
            content: alertDialogContent,
          );
        },
      );
    },
  );
}

Widget _alertContentInitial({
  @required BuildContext context,
  @required LandingPageRecoverPasswordDialogController controller,
}) {
  final _formKey = GlobalKey<FormState>();
  return SingleChildScrollView(
    child: Column(
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
            validator: controller.validateEmail,
            onChanged: controller.setEmail,
          ),
        ),
        SizedBox(height: 30),
        RaisedButton(
          child: Text(
            'Reset Password',
            style: TextStyle(fontSize: 14),
          ),
          elevation: 0,
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              controller.resetPassword();
            }
          },
        ),
      ],
    ),
  );
}

Widget _alertContentFinish({
  @required BuildContext context,
  @required LandingPageRecoverPasswordDialogController controller,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Text(controller.message),
        SizedBox(height: 30),
        RaisedButton(
          child: Text(
            'Retry',
            style: TextStyle(fontSize: 14),
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          onPressed: () {
            controller.retry();
          },
        ),
      ],
    ),
  );
}
