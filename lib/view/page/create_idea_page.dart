import 'package:flutter/material.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';
import 'package:idea_tracker/controller/page/create_idea_page_controller.dart';

class CreateIdeaPage extends StatelessWidget {
  final String title;
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  void _onFieldSubmitted(String value) {
    _focusNode.requestFocus();
  }

  CreateIdeaPage(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onIdeaCreated = (String content) {
      Navigator.pop(context);
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(content),
        ));
      });
    };

    return BaseView<CreateIdeaPageController>(
      onControllerReady: (controller) {
        controller.onIdeaCreated = onIdeaCreated;
      },
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(title),
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
                    autofocus: true,
                    onFieldSubmitted: _onFieldSubmitted,
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
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
                  ),
                  SizedBox(height: 12),
                  RaisedButton.icon(
                    icon: Icon(
                      Icons.add,
                      size: 26,
                    ),
                    label: Text(
                      'CREATE',
                      style: TextStyle(fontSize: 16),
                    ),
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        controller.createIdea();
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
