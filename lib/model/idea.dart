class Idea {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final int createdAt;
  final int updatedAt;
  final int voteYes;
  final int voteNo;
  final List<String> voters;

  Idea({
    this.id,
    this.title,
    this.description,
    this.creatorId,
    this.createdAt,
    this.updatedAt,
    this.voteYes,
    this.voteNo,
    this.voters,
  });

  Idea copyWith({
    String id,
    String title,
    String description,
    String creatorId,
    int createdAt,
    int updatedAt,
    int voteYes,
    int voteNo,
    List<String> voters,
  }) {
    return Idea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      voteYes: voteYes ?? this.voteYes,
      voteNo: voteNo ?? this.voteNo,
      voters: voters ?? this.voters,
    );
  }

  /// print the current stored idea to a string for debugging purposes
  toString() {
    return 'Idea: id: ${this.id ?? 'null'}, '
        'title: ${this.title ?? 'null'}, '
        'description: ${this.description ?? 'null'}, '
        'creatorId: ${this.creatorId ?? 'null'}, '
        'createdAt: ${this.createdAt ?? 'null'}, '
        'updatedAt: ${this.updatedAt  ?? 'null'}, '
        'creatorId: ${this.creatorId ?? 'null'}, '
        'voteYes: ${this.voteYes ?? 'null'}, '
        'voteNo: ${this.voteNo ?? 'null'}, '
        'voters: ${this.voters ?? 'null'}';
  }
}
