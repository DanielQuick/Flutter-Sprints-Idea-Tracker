import 'package:flutter/material.dart';
import 'package:idea_tracker/view/widget/state_management/base_view.dart';
import 'package:idea_tracker/controller/page/create_idea_controller.dart';

class CreateIdeaPage extends StatelessWidget {
  final String title;
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  void _onFieldSubmitted(String value) {
    _focusNode.requestFocus();
  }

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
          body: Builder(
            builder: (context) {
              // Temporary solution to show some feedback
              if (controller.ideaCreatedSuccesfully) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Your idea has been created"),
                  ));
                });
              }

              return Form(
                key: _formKey,
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
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Idea Description",
                      ),
                      validator: controller.validateDescription,
                      onChanged: controller.setIdeaDescription,
                      focusNode: _focusNode,
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                controller.createIdea();
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
