import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/sprint.dart';
import 'package:idea_tracker/service/sprint_service.dart';

class SprintsPageController extends ChangeNotifier {
  final _sprintService = locator<SprintService>();

  List<Sprint> _sprints;

  List<Sprint> get sprints => _sprints ?? [];

  set sprints(List<Sprint> value) {
    if (_sprints == value) return;

    _sprints = value;
    notifyListeners();
  }

  initialize() async {
    sprints = await _sprintService.getAll();
  }
}