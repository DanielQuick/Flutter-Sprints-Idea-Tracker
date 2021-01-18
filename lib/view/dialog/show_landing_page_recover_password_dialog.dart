import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/dialog/landing_page_recover_password_dialog_controller.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

Future showLandingPageRecoverPasswordDialog({
  @required BuildContext context,
  @required String title,
}) async {
  return showDialog(
    context: context,
    // User must press "Close" button. Eventually, this behavior will change
    barrierDismissible: false,
    builder: (context) {
      return BaseView<LandingPageRecoverPasswordDialogController>(
        builder: (context, controller, child) {
          Widget alertDialogContent;

          switch (controller.status) {
            case RecoverPasswordStatus.initial:
              alertDialogContent = _alertContentInitial(
                context: context,
                controller: controller,
              );
              break;
            case RecoverPasswordStatus.waiting:
              alertDialogContent = _alertContentWaiting(
                context: context,
              );
              break;
            case RecoverPasswordStatus.failed:
              alertDialogContent = _alertContentFailed(
                context: context,
                controller: controller,
              );
              break;
            case RecoverPasswordStatus.success:
              alertDialogContent = _alertContentSuccess(
                context: context,
                controller: controller,
              );
              break;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RaisedButton(
              child: Text(
                'Close',
                style: TextStyle(fontSize: 14),
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
        )
      ],
    ),
  );
}

Widget _alertContentWaiting({@required BuildContext context}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Text("Please, check your inbox"),
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
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _alertContentSuccess({
  @required BuildContext context,
  @required LandingPageRecoverPasswordDialogController controller,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Text("Password has been reset succesfully"),
        SizedBox(height: 30),
        RaisedButton(
          child: Text(
            'Close',
            style: TextStyle(fontSize: 14),
          ),
          elevation: 0,
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget _alertContentFailed({
  @required BuildContext context,
  @required LandingPageRecoverPasswordDialogController controller,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Text("An error has ocurred"),
        SizedBox(height: 30),
        RaisedButton(
          child: Text(
            'Close',
            style: TextStyle(fontSize: 14),
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
