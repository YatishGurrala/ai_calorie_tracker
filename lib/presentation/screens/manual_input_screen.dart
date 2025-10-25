import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/food_log_cubit.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({Key? key}) : super(key: key);

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String _foodName = '';
  String _description = '';

  void _submitFood() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // TODO: Implement food detection with text input
      // context.read<FoodLogCubit>().addMealFromText(_foodName, _description);
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Food Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  hintText: 'e.g., Grilled Chicken Breast',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _foodName = value ?? '';
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'e.g., 200g with vegetables',
                ),
                maxLines: 3,
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitFood,
                child: Text('Get Nutrition Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}