import 'package:flutter/material.dart';
import 'package:idea_tracker/model/idea.dart';

class CreateIdeaPageController extends ChangeNotifier {
  String _ideaTitle;
  String _ideaDescription;
  Function(String) onIdeaCreated;

  void setIdeaTitle(String title) {
    _ideaTitle = title;
  }

  void setIdeaDescription(String description) {
    _ideaDescription = description;
  }

  String validateTitle(String value) {
    if (value.isEmpty) {
      return 'Please enter idea title';
    } else if (value.length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  String validateDescription(String value) {
    if (value.isEmpty) {
      return 'Please enter idea description';
    } else if (value.length < 3) {
      return 'Description must be at least 3 characters';
    }
    return null;
  }

  void createIdea() async {
    // TODO: POST idea throught IdeaService
    final idea = await Future.delayed(Duration(milliseconds: 1000), () {
      final idea = Idea(
        id: "1",
        title: _ideaTitle,
        description: _ideaDescription,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      return idea;
    });
    if (onIdeaCreated != null) onIdeaCreated("Success!");
    print(
        "Idea created => id: ${idea.id} | title: ${idea.title} | description: ${idea.description} | createdAt: ${idea.createdAt} | updatedAt: ${idea.updatedAt} | votes: ${idea.votes}");
  }
}
