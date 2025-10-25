import 'package:flutter/material.dart';
import '../../data/models/post.dart';
import '../../data/models/food_item.dart';
import '../widgets/post_card.dart';

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual posts from Firestore
    final List<Post> posts = [
      Post(
        id: '1',
        userId: 'user1',
        caption: 'Healthy lunch today! 🥗',
        foodItem: FoodItem(
          id: '1',
          name: 'Chicken Salad',
          calories: 350,
          protein: 25,
          carbs: 15,
          fat: 12,
          quantity: 250,
          imageUrl: 'https://picsum.photos/400/300',
          timestamp: DateTime.now(),
        ),
        imageUrl: 'https://picsum.photos/400/300',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Post(
        id: '2',
        userId: 'user2',
        caption: 'Protein-packed dinner 💪',
        foodItem: FoodItem(
          id: '2',
          name: 'Grilled Salmon',
          calories: 450,
          protein: 35,
          carbs: 10,
          fat: 18,
          quantity: 200,
          imageUrl: 'https://picsum.photos/400/301',
          timestamp: DateTime.now(),
        ),
        imageUrl: 'https://picsum.photos/400/301',
        createdAt: DateTime.now().subtract(Duration(hours: 4)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Social Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No posts yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Be the first to share your meal!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create post screen
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
