import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/sprint.dart';
import 'package:idea_tracker/service/authentication_service.dart';
import 'package:idea_tracker/service/sprint_service.dart';

class SprintsDetailsController extends ChangeNotifier {
  Sprint _currentSprint;
  final _sprintService = locator<SprintService>();
  final _authService = locator<AuthenticationService>();

  Sprint get currentSprint => _currentSprint;

  set currentSprint(Sprint sprint){
    _currentSprint = sprint;
    notifyListeners();
  }

  void addSprintMember() async {
    currentSprint = await _sprintService.update(currentSprint, [UpdateSprint.addMember], [_authService.getAuthenticatedUser().id]);
  }

}