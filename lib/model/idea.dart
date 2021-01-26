class Idea {
  final String id;
  final String title;
  final String description;
  final String userId;
  final int createdAt;
  final int updatedAt;
  final List<String> votes;

  Idea({
    this.id,
    this.title,
    this.description,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.votes,
  });

  Idea copyWith({
    String id,
    String title,
    String description,
    String userId,
    int createdAt,
    int updatedAt,
    List<String> votes,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      votes: votes ?? this.votes,
    );
  }
}
