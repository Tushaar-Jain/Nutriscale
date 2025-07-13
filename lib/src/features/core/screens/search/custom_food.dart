import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutriscale/src/features/core/models/food_item.dart';
import 'package:nutriscale/src/features/core/controllers/calorie_controller.dart';
import 'package:nutriscale/src/features/core/screens/search/custom_food_screen.dart';


class CustomFoodScreen extends StatelessWidget {
  final calorieController = Get.find<CalorieController>();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Custom Foods")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('custom_foods')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No custom foods added."));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final item = FoodItem.fromFirestore(data);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    "${item.calories.toStringAsFixed(0)} kcal | "
                    "Protein: ${item.protein}g | Carbs: ${item.carbs}g | Fat: ${item.fat}g",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      calorieController.addFoodItem(item);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item.name} added to daily total!")),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddCustomFoodScreen()),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
