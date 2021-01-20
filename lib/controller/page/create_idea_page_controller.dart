import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/service/idea_service.dart';

class CreateIdeaPageController extends ChangeNotifier {
  String _ideaTitle;
  String _ideaDescription;
  Function(String) onIdeaCreated;

  final _ideaService = locator<IdeaService>();

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
    final idea = await _ideaService.create(
      Idea(
        title: _ideaTitle,
        description: _ideaDescription,
      ),
    );
    if (onIdeaCreated != null) onIdeaCreated("Success!");
    print(
        "Idea created => id: ${idea.id} | title: ${idea.title} | description: ${idea.description} | createdAt: ${idea.createdAt} | updatedAt: ${idea.updatedAt} | votes: ${idea.votes}");
  }
}
