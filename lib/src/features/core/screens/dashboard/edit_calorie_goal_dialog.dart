import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/calorie_controller.dart';

class EditCalorieGoalDialog extends StatelessWidget {
  EditCalorieGoalDialog({super.key});

  final TextEditingController _goalController = TextEditingController();
  final calorieController = Get.find<CalorieController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Daily Calorie Limit"),
      content: TextField(
        controller: _goalController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: "Enter calorie limit",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final input = double.tryParse(_goalController.text);
            if (input != null && input > 0) {
              calorieController.setCalorieGoal(input);
              Get.back(); // Close dialog
            } else {
              Get.snackbar("Invalid Input", "Please enter a valid number",
                  snackPosition: SnackPosition.BOTTOM);
            }
          },
          child: const Text("Done"),
        ),
      ],
    );
  }
}
