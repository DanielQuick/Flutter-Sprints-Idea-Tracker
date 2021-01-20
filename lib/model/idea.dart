class Idea {
  final String id;
  final String title;
  final String creatorId;
  final String description;
  final int createdAt;
  final int updatedAt;
  final List<Map<String, dynamic>> votes;

  Idea({
    this.id,
    this.title,
    this.creatorId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.votes,
  });

  Idea copyWith({
    String id,
    String creatorId,
    String title,
    String description,
    int createdAt,
    int updatedAt,
    List<Map<String, dynamic>> votes,
  }) {
    return Idea(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      votes: votes ?? this.votes,
    );
  }

  /// print the current stored idea to a string for debugging purposes
  toString() {
    return 'Idea: id: ${this.id}, '
        'title: ${this.title}, '
        'description: ${this.description}, '
        'createdAt: ${this.createdAt}, '
        'updatedAt: ${this.updatedAt}, '
        'creatorId: ${this.creatorId} '
        'votes: ${this.votes}';
  }
}
