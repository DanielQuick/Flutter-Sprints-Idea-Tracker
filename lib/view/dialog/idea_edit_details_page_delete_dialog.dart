import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/dialog/idea_edit_details_page_delete_dialog_controller.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

Future<bool> showIdeaEditDetailsPageDeleteDialog({
  @required BuildContext context,
  @required String title,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return BaseView<IdeaEditDetailsPageDeleteDialogController>(
        onControllerReady: (controller) {
          controller.onConfirmDelete = () {
            Navigator.pop(context, true);
          };
        },
        builder: (context, controller, child) {
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
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Are you sure you want to delete this idea?",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        child: Text(
                          'CANCEL',
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
                          'CONFIRM',
                          style: TextStyle(fontSize: 14),
                        ),
                        elevation: 0,
                        textColor: Colors.white,
                        color: Theme.of(context).errorColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          controller.confirmDelete();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
