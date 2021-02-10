import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/landing_page_controller.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class ShowAuthError extends StatelessWidget {
  final errorMessage;
  const ShowAuthError(this.errorMessage, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LandingController>(
        onControllerReady: (controller) {

        },
        builder: (context, controller, child) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text(errorMessage + '\nPlease Try Again.'),
            actions: [
              FlatButton(
                padding: EdgeInsets.all(0),
                color: Theme.of(context).buttonColor,
                onPressed: () => Navigator.of(context).pop(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
