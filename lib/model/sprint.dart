class Sprint {
  final String id;
  final String title;
  final String description;
  final int createdAt;
  final int updatedAt;
  final String teamLeader;
  final List<String> members;
  final List<String> potentialLeaders;
  List<SprintPost> posts;

  Sprint({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.members,
    this.teamLeader,
    this.potentialLeaders,
    this.posts,
  });

  Sprint copyWith({
    String id,
    String title,
    String description,
    int createdAt,
    int updatedAt,
    List<String> votes,
    List<String> members,
    String teamLeader,
    List<String> potentialLeaders,
    List<SprintPost> posts,
  }) {
    return Sprint(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      members: members ?? this.members,
      teamLeader: teamLeader ?? this.teamLeader,
      potentialLeaders: potentialLeaders ?? this.potentialLeaders,
      posts: posts ?? this.posts,
    );
  }
}

class SprintPost {
  final int id;
  final String title;
  final String content;
  final int createdAt;

  SprintPost({
    this.id,
    this.title,
    this.content,
    this.createdAt,
  });

  SprintPost copyWith({
    int id,
    String title,
    String content,
    int createdAt,
  }) {
    return SprintPost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
