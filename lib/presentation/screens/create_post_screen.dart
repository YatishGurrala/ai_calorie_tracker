import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../data/models/food_item.dart';
import '../../data/models/post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _image;
  final _captionController = TextEditingController();
  bool _isLoading = false;
  FoodItem? _detectedFood;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _detectFood();
    }
  }

  Future<void> _detectFood() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Use your existing FoodService to detect food
      // final result = await foodService.detectFoodAndCalories(_image!);
      // result.fold(
      //   (error) => ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(error)),
      //   ),
      //   (foodItem) => setState(() => _detectedFood = foodItem),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error detecting food: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createPost() async {
    if (_image == null || _detectedFood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add an image and detect food first')),
      );
      return;
    }

    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add a caption')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Upload image to Firebase Storage and get URL
      // final imageUrl = await storageService.uploadImage(_image!);

      final post = Post(
        id: DateTime.now().toString(),
        userId: 'currentUserId', // TODO: Replace with actual user ID
        caption: _captionController.text.trim(),
        foodItem: _detectedFood!,
        imageUrl: _image?.path, // TODO: Replace with Firebase Storage URL
      );

      // TODO: Save post to Firestore
      // await postRepository.createPost(post);

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              _getImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              _getImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        actions: [
          if (_image != null && _detectedFood != null)
            TextButton(
              onPressed: _isLoading ? null : _createPost,
              child: Text(
                'Share',
                style: TextStyle(
                  color: _isLoading ? Colors.grey : Colors.blue,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_image == null)
                    InkWell(
                      onTap: _showImageSourceActionSheet,
                      child: Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 64),
                            SizedBox(height: 16),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    )
                  else
                    Stack(
                      children: [
                        Image.file(
                          _image!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => setState(() {
                              _image = null;
                              _detectedFood = null;
                            }),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_detectedFood != null) ...[
                          Text(
                            'Detected Food:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _detectedFood!.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Calories: ${_detectedFood!.calories.toStringAsFixed(0)} kcal',
                                  ),
                                  Text(
                                    'Protein: ${_detectedFood!.protein.toStringAsFixed(1)}g',
                                  ),
                                  Text(
                                    'Carbs: ${_detectedFood!.carbs.toStringAsFixed(1)}g',
                                  ),
                                  Text(
                                    'Fat: ${_detectedFood!.fat.toStringAsFixed(1)}g',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        TextField(
                          controller: _captionController,
                          decoration: InputDecoration(
                            hintText: 'Write a caption...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
