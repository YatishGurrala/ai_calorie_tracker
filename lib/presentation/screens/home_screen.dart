import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../cubit/food_log_cubit.dart';
import '../widgets/daily_tracker.dart';
import '../widgets/meal_list.dart';
import '../widgets/alert_message_widget.dart';
import 'manual_input_screen.dart';
import 'camera_screen.dart';
import 'barcode_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void _openCameraScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );
  }

  void scanBarcode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
    );
  }

  void showManualInputScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManualInputScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's trackers",
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 16),
                BlocBuilder<FoodLogCubit, FoodLogState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      children: [
                        // Tracker Section
                        DailyTracker(
                          calories: state.totalCalories,
                          protein: state.totalProtein,
                          carbs: state.totalCarbs,
                          fat: state.totalFat,
                        ),
                        SizedBox(height: 24),

                        // Inline Alert Section for Success or Error
                        if (state.successMessage != null || state.error != null)
                          AlertMessageWidget(
                            errorMessage: state.error,
                            successMessage: state.successMessage,
                            onClose: () =>
                                context.read<FoodLogCubit>().clearMessages(),
                          ),

                        // Meals Section
                        Text('Meals',
                            style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 16),
                        MealList(meals: state.meals),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        spacing: 15,
        direction: SpeedDialDirection.up,
        renderOverlay: true,
        useRotationAnimation: true,
        // Order children so the first child is the nearest (bottom) and the
        // last child in the list is the farthest (top) when expanding upward.
        children: [
          // 3) BOTTOM (nearest)
          SpeedDialChild(
            child: const Icon(Icons.edit),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: 'Manual',
            labelStyle: const TextStyle(fontSize: 16.0),
            onTap: () => showManualInputScreen(),
          ),
          // 2) MIDDLE
          SpeedDialChild(
            child: const Icon(Icons.qr_code_scanner),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Barcode',
            labelStyle: const TextStyle(fontSize: 16.0),
            onTap: () => scanBarcode(),
          ),
          // 1) TOP (farthest)
          SpeedDialChild(
            child: const Icon(Icons.camera_alt),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Camera',
            labelStyle: const TextStyle(fontSize: 16.0),
            onTap: () => _openCameraScreen(context),
          ),
        ],
      ),
    );
  }
}
