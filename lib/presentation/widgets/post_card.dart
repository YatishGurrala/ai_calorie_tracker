import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../data/models/post.dart';
import '../screens/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  post.imageUrl != null ? NetworkImage(post.imageUrl!) : null,
              child: post.imageUrl == null
                  ? Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            title: Text('User Name'), // TODO: Replace with actual user name
            subtitle: Text(timeago.format(post.createdAt)),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Report'),
                  onTap: () {
                    // TODO: Implement report functionality
                  },
                ),
              ],
            ),
          ),

          // Food Image
          if (post.foodItem.imageUrl != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post),
                  ),
                );
              },
              child: Image.network(
                post.foodItem.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

          // Caption and Food Details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.caption,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 8),
                Text(
                  '${post.foodItem.name} • ${post.foodItem.calories.toStringAsFixed(0)} kcal',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),

          // Engagement Actions
          Row(
            children: [
              IconButton(
                icon: Icon(
                  post.likes.contains(
                          'currentUserId') // TODO: Replace with actual user ID
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:
                      post.likes.contains('currentUserId') ? Colors.red : null,
                ),
                onPressed: () {
                  // TODO: Implement like functionality
                },
              ),
              Text('${post.likes.length}'),
              IconButton(
                icon: Icon(Icons.comment_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(post: post),
                    ),
                  );
                },
              ),
              Text('0'), // TODO: Replace with actual comment count
            ],
          ),
        ],
      ),
    );
  }
}
