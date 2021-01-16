export 'authentication_service.dart';
export 'idea_service.dart';
export 'sprint_service.dart';
export 'user_service.dart';

/// the current time, in “seconds since the epoch”
int currentTimeInSeconds() {
  var ms = (new DateTime.now()).millisecondsSinceEpoch;
  return (ms / 1000).round();
}
