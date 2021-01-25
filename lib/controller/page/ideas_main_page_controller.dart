import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/idea.dart';
import 'package:idea_tracker/service/idea_service.dart';

class IdeasMainPageController extends ChangeNotifier {
  List<Idea> _ideas = [];

  List<Idea> get ideas => _ideas;

  set ideas(List<Idea> value) {
    if (_ideas == value) return;
    _ideas = value;
    notifyListeners();
  }

  initialize() async {
    ideas = await locator<IdeaService>().getAll();
  }
}
