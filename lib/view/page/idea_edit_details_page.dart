import 'package:flutter/material.dart';
import 'package:idea_tracker/controller/page/idea_edit_details_page_controller.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/view/dialog/idea_edit_details_page_delete_dialog.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';

class IdeaEditDetailsPage extends StatelessWidget {
  final String title;
  final Idea idea;
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  void _onFieldSubmitted(String value) {
    _focusNode.requestFocus();
  }

  IdeaEditDetailsPage(this.title, this.idea, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onDataUpdated = (String content) {
      Navigator.pop(context);

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(content),
      ));
    };
    final onOpenDeleteDialog = () async {
      return await showIdeaEditDetailsPageDeleteDialog(
        context: context,
        title: "Delete Idea",
      );
    };

    return BaseView<IdeaEditDetailsPageController>(
      onControllerReady: (controller) {
        controller.currentIdea = this.idea;
        controller.onDataUpdated = onDataUpdated;
        controller.onOpenDeleteDialog = onOpenDeleteDialog;
      },
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(title),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  controller.openDeleteDialog();
                },
              )
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 28,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Idea Title",
                    ),
                    validator: controller.validateTitle,
                    onChanged: controller.setIdeaTitle,
                    onFieldSubmitted: _onFieldSubmitted,
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    initialValue: controller.currentIdea.title,
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Idea Description",
                    ),
                    validator: controller.validateDescription,
                    onChanged: controller.setIdeaDescription,
                    focusNode: _focusNode,
                    maxLength: 500,
                    maxLengthEnforced: false,
                    maxLines: 16,
                    initialValue: controller.currentIdea.description,
                  ),
                  SizedBox(height: 12),
                  RaisedButton.icon(
                    icon: Icon(
                      Icons.save,
                      size: 26,
                    ),
                    label: Text(
                      'SAVE',
                      style: TextStyle(fontSize: 16),
                    ),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //controller.saveChanges();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
