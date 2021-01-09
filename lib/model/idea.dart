class Idea {
  final String id;
  final String title;
  final String description;
  final int createdAt;
  final int updatedAt;
  final List<String> votes;

  Idea({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.votes,
  });

  Idea copyWith({
    String id,
    String title,
    String description,
    int createdAt,
    int updatedAt,
    List<String> votes,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      votes: votes ?? this.votes,
    );
  }
}
