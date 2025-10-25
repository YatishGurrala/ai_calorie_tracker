class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final List<String> followers;
  final List<String> following;
  final DateTime createdAt;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    List<String>? followers,
    List<String>? following,
    DateTime? createdAt,
    this.bio,
  })  : followers = followers ?? [],
        following = following ?? [],
        createdAt = createdAt ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        photoUrl: json['photoUrl'] as String?,
        followers: (json['followers'] as List<dynamic>?)?.cast<String>() ?? [],
        following: (json['following'] as List<dynamic>?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(json['createdAt'] as String),
        bio: json['bio'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'followers': followers,
        'following': following,
        'createdAt': createdAt.toIso8601String(),
        'bio': bio,
      };

  User copyWith({
    String? name,
    String? photoUrl,
    String? bio,
    List<String>? followers,
    List<String>? following,
  }) {
    return User(
      id: this.id,
      email: this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: this.createdAt,
    );
  }
}
