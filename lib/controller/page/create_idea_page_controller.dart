import 'package:flutter/material.dart';
import 'package:idea_tracker/model/idea.dart';

class CreateIdeaPageController extends ChangeNotifier {
  String _ideaTitle;
  String _ideaDescription;
  bool _ideaCreatedSuccesfully = false;

  bool get ideaCreatedSuccesfully => _ideaCreatedSuccesfully;

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

  void createIdea() {
    // TODO: POST idea throught IdeaService
    Future.delayed(Duration(milliseconds: 1000), () {
      final _idea = Idea(
        id: "1",
        title: _ideaTitle,
        description: _ideaDescription,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      _ideaCreatedSuccesfully = true;
      notifyListeners();

      print(
          "Idea created => id: ${_idea.id} | title: ${_idea.title} | description: ${_idea.description} | createdAt: ${_idea.createdAt} | updatedAt: ${_idea.updatedAt} | votes: ${_idea.votes}");
    });
  }
}
