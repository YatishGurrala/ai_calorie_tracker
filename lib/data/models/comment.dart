class Comment {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as String,
        postId: json['postId'] as String,
        userId: json['userId'] as String,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'userId': userId,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  Comment copyWith({
    String? text,
  }) {
    return Comment(
      id: this.id,
      postId: this.postId,
      userId: this.userId,
      text: text ?? this.text,
      createdAt: this.createdAt,
    );
  }
}
