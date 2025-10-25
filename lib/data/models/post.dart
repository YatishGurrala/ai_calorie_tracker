import 'food_item.dart';

class Post {
  final String id;
  final String userId;
  final String caption;
  final FoodItem foodItem;
  final List<String> likes;
  final DateTime createdAt;
  final String? imageUrl;

  Post({
    required this.id,
    required this.userId,
    required this.caption,
    required this.foodItem,
    List<String>? likes,
    DateTime? createdAt,
    this.imageUrl,
  })  : likes = likes ?? [],
        createdAt = createdAt ?? DateTime.now();

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as String,
        userId: json['userId'] as String,
        caption: json['caption'] as String,
        foodItem: FoodItem.fromJson(json['foodItem'] as Map<String, dynamic>),
        likes: (json['likes'] as List<dynamic>?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(json['createdAt'] as String),
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'caption': caption,
        'foodItem': foodItem.toJson(),
        'likes': likes,
        'createdAt': createdAt.toIso8601String(),
        'imageUrl': imageUrl,
      };

  Post copyWith({
    String? caption,
    FoodItem? foodItem,
    List<String>? likes,
    String? imageUrl,
  }) {
    return Post(
      id: this.id,
      userId: this.userId,
      caption: caption ?? this.caption,
      foodItem: foodItem ?? this.foodItem,
      likes: likes ?? this.likes,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: this.createdAt,
    );
  }
}
