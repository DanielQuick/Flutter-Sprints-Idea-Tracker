import 'package:flutter/foundation.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/service/idea_service.dart';

class IdeaEditDetailsPageController extends ChangeNotifier {
  Idea _currentIdea;
  Function(String) onDataUpdated;
  Future<bool> Function() onOpenDeleteDialog;

  final _ideaService = locator<IdeaService>();

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
    final idea = await _ideaService.update(idea: _currentIdea);
    if (onDataUpdated != null) onDataUpdated("Success!");
    print(
        "Idea updated => id: ${idea.id} | title: ${idea.title} | description: ${idea.description} | createdAt: ${idea.createdAt} | updatedAt: ${idea.updatedAt} | votes: ${idea.votes}");
  }

  void openDeleteDialog() async {
    if (onOpenDeleteDialog != null) {
      final confirmDelete = await onOpenDeleteDialog();

      // Check with "==" because "confirmDelete" will be "null"
      // if dialog is dismissed
      if (confirmDelete == true) {
        await _ideaService.delete(idea: _currentIdea);
        print("Idea deleted");
        if (onDataUpdated != null) onDataUpdated("Success!");
      }
    }
  }
}
