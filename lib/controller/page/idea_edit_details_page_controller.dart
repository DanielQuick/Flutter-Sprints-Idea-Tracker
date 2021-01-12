import 'package:flutter/foundation.dart';
import 'package:idea_tracker/model/idea.dart';

class IdeaEditDetailsPageController extends ChangeNotifier {
  Idea _currentIdea;

  Idea get currentIdea => _currentIdea;

  void loadIdea(String id) {
    // TODO: load from Firebase
    _currentIdea = Idea(
      id: id,
      title: "Awesome idea",
      description: "This is the description of the idea.",
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void setIdeaTitle(String title) {
    _currentIdea = _currentIdea.copyWith(title: title);
  }

  void setIdeaDescription(String description) {
    _currentIdea = _currentIdea.copyWith(description: description);
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

  void saveChanges() {
    // TODO: POST idea throught IdeaService
    Future.delayed(Duration(milliseconds: 1000), () {
      final _updatedIdea = _currentIdea.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      print(
        "Idea updated => id: ${_updatedIdea.id} | title: ${_updatedIdea.title} | description: ${_updatedIdea.description} | createdAt: ${_updatedIdea.createdAt} | updatedAt: ${_updatedIdea.updatedAt} | votes: ${_updatedIdea.votes}",
      );
    });
  }
}
