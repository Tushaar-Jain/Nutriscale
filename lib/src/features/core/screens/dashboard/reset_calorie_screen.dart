import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/features/core/controllers/calorie_controller.dart';

class ResetCalorieScreen extends StatelessWidget {
  final calorieController = Get.find<CalorieController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Food Log"),backgroundColor: primaryAppColor,),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This ensures the list takes only available space
              Expanded(
                child: Obx(() {
                  final items = calorieController.addedFoodItems;

                  if (items.isEmpty) {
                    return const Center(
                      child: Text("No food items added today."),
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        shadowColor: primaryAppColor,
                        child: ListTile(
                          title: Text(item.name,style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(
                            "${item.calories.toStringAsFixed(0)} kcal | "
                            "Protein: ${item.protein.toStringAsFixed(1)}g | "
                            "Carbs: ${item.carbs.toStringAsFixed(1)}g | "
                            "Fat: ${item.fat.toStringAsFixed(1)}g",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () => calorieController.removeFoodItem(index),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAppColor,
                  ),
                  onPressed: () {
                    calorieController.reset();
                    Get.snackbar("Reset", "Calorie data has been reset");
                  },
                  child: Text(
                    "Reset All",
                    style: TextStyle(
                      color: isDark ? secondaryAppColor : appBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
