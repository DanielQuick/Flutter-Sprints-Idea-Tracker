import 'package:flutter/foundation.dart';
import 'package:idea_tracker/model/idea.dart';

class IdeaEditDetailsPageController extends ChangeNotifier {
  Idea _currentIdea;
  Function(String) onChangesSaved;

  Idea get currentIdea => _currentIdea;

  set currentIdea(Idea idea) {
    _currentIdea = idea;
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

  void saveChanges() async {
    // TODO: POST idea throught IdeaService
    final updatedIdea = await Future.delayed(Duration(milliseconds: 1000), () {
      final updatedIdea = _currentIdea.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      return updatedIdea;
    });
    if (onChangesSaved != null) onChangesSaved("Success!");
    print(
        "Idea updated => id: ${updatedIdea.id} | title: ${updatedIdea.title} | description: ${updatedIdea.description} | createdAt: ${updatedIdea.createdAt} | updatedAt: ${updatedIdea.updatedAt} | votes: ${updatedIdea.votes}");
  }
}
