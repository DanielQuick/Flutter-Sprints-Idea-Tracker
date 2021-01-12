import 'package:flutter/material.dart';
import 'package:idea_tracker/model/idea.dart';

class CreateIdeaController extends ChangeNotifier {
  String _ideaTitle;
  String _ideaDescription;

  set ideaTitle(String title) {
    _ideaTitle = title;
    notifyListeners();
  }

  set ideaDescription(String description) {
    _ideaDescription = description;
    notifyListeners();
  }

  onCreateIdeaFabPressed() {
    final _idea = Idea(
      id: "1",
      title: _ideaTitle,
      description: _ideaDescription,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    // TODO: POST idea throught Service
  }
}
