import 'package:flutter/material.dart';
import 'package:idea_tracker/locator.dart';
import 'package:idea_tracker/model/sprint.dart';
import 'package:idea_tracker/service/sprint_service.dart';

class CreateSprintPageController extends ChangeNotifier{
  String _sprintTitle;
  String _sprintDescription;
  String _sprintTeamleader;
  Function(String) onSprintCreated;

  final _sprintService = locator<SprintService>();

  void setSprintTitle(String title){
    _sprintTitle = title;
  }

  void setSprintDescription(String description){
    _sprintDescription = description;
  }

  void setSprintTeamleader(String teamleader){
    _sprintTeamleader = teamleader;
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

  String validateTeamleader(String value) {
    if (value.isEmpty) {
      return 'Please enter a teamleader';
    }
    return null;
  }

  void createSprint() async {
    final sprint = await _sprintService.create(
      Sprint(
        title: _sprintTitle,
        description: _sprintDescription,
        teamLeader: _sprintTeamleader,
      ),
    );
    if(onSprintCreated != null) onSprintCreated("Succes!");
    print(sprint.toString());
  }
}