import 'package:flutter/material.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';
import 'package:idea_tracker/controller/page/create_idea_controller.dart';

class CreateIdeaPage extends StatelessWidget {
  final String title;
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  CreateIdeaPage({this.title});

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateIdeaController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(title),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Idea Title",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter idea title';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    controller.ideaTitle = value;
                  },
                  autofocus: true,
                  onFieldSubmitted: (_) {
                    _focusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Idea Description",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter idea description';
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    controller.ideaDescription = value;
                  },
                  focusNode: _focusNode,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                controller.onCreateIdeaFabPressed();
              }
            },
            label: Text('Create'),
            icon: Icon(Icons.add),
            tooltip: 'Create Idea',
          ),
        );
      },
    );
  }
}
