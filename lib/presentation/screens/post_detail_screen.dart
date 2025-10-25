import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../data/models/post.dart';
import '../../data/models/comment.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> comments =
      []; // TODO: Replace with actual comments from Firestore

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    // TODO: Implement adding comment to Firestore
    setState(() {
      comments.add(
        Comment(
          id: DateTime.now().toString(),
          postId: widget.post.id,
          userId: 'currentUserId', // TODO: Replace with actual user ID
          text: _commentController.text.trim(),
        ),
      );
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Post Content
                if (widget.post.foodItem.imageUrl != null)
                  Image.network(
                    widget.post.foodItem.imageUrl!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: widget.post.imageUrl != null
                                ? NetworkImage(widget.post.imageUrl!)
                                : null,
                            child: widget.post.imageUrl == null
                                ? Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Name', // TODO: Replace with actual user name
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                timeago.format(widget.post.createdAt),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.post.caption,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${widget.post.foodItem.name} • ${widget.post.foodItem.calories.toStringAsFixed(0)} kcal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              widget.post.likes.contains(
                                      'currentUserId') // TODO: Replace with actual user ID
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.post.likes.contains('currentUserId')
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () {
                              // TODO: Implement like functionality
                            },
                          ),
                          Text('${widget.post.likes.length} likes'),
                          SizedBox(width: 16),
                          Icon(Icons.comment_outlined),
                          SizedBox(width: 8),
                          Text('${comments.length} comments'),
                        ],
                      ),
                      Divider(),
                      // Comments Section
                      Text(
                        'Comments',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      ...comments.map((comment) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  child: Icon(Icons.person, size: 20),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'User Name', // TODO: Replace with actual user name
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            timeago.format(comment.createdAt),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(comment.text),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Comment Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
