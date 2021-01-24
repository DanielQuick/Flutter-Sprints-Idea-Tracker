import 'package:idea_tracker/model/sprint.dart';

class SprintService {
  /// Create [sprint]
  Future<Sprint> create({Sprint sprint}) async {
    return sprint.copyWith(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Update [sprint]
  Future<Sprint> update({Sprint sprint}) async {
    return sprint.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch);
  }

  /// Delete [sprint]
  Future<void> delete({Sprint sprint}) async {}

  /// Get Sprint with [id]
  ///
  /// Return null if none found
  Future<Sprint> get({String id}) async {
    return Sprint(
      id: "id",
      title: "title",
      description: "description",
      createdAt: 0,
      updatedAt: 0,
    );
  }

  /// Get all sprints for this month
  Future<List<Sprint>> getAll() async {
    return [0, 1, 2, 3, 4, 5]
        .map(
          (e) => Sprint(
            id: e.toString(),
            title: "title $e",
            description: "description $e",
            createdAt: e,
            updatedAt: e,
          ),
        )
        .toList();
  }
}
