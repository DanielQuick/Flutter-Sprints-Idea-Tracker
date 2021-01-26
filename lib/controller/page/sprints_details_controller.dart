import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/sprint.dart';
import 'package:idea_tracker/service/sprint_service.dart';

class SprintsDetailsController extends ChangeNotifier {
  Sprint _currentSprint;
  final _sprintService = locator<SprintService>();

  Sprint get currentSprint => _currentSprint;

  set currentSprint(Sprint sprint){
    _currentSprint = sprint;
  }

  void addSprintMember(String member){
    
  }

}