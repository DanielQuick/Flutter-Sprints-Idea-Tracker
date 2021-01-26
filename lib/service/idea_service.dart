import 'package:idea_tracker/model/idea.dart';

class IdeaService {
  /// Create [idea]
  Future<Idea> create({Idea idea}) async {
    return idea.copyWith(
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Delete [idea]
  Future<void> delete({Idea idea}) async {}

  /// Update [idea]
  Future<Idea> update({Idea idea}) async {
    return idea.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch);
  }

  /// Return Idea with [id] if available
  ///
  /// Returns [null] if none found
  Future<Idea> get({String id}) async {
    return Idea(
      id: "id",
      title: "title",
      description: "Description",
      createdAt: 0,
      updatedAt: 0,
    );
  }

  /// Return all ideas created this month
  Future<List<Idea>> getAll() async {
    return [0, 1, 2, 3, 4, 5]
        .map(
          (e) => Idea(
            id: e.toString(),
            title: "title $e",
            description: "Description $e",
            createdAt: e,
            updatedAt: e,
          ),
        )
        .toList();
  }
}
