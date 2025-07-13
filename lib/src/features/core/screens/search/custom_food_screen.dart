import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomFoodScreen extends StatefulWidget {
  const AddCustomFoodScreen({super.key});

  @override
  State<AddCustomFoodScreen> createState() => _AddCustomFoodScreenState();
}

class _AddCustomFoodScreenState extends State<AddCustomFoodScreen> {
  final nameController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to check form validity
    nameController.addListener(_validateForm);
    caloriesController.addListener(_validateForm);
    proteinController.addListener(_validateForm);
    carbsController.addListener(_validateForm);
    fatController.addListener(_validateForm);
  }

  void _validateForm() {
    final isFilled = nameController.text.trim().isNotEmpty &&
        caloriesController.text.trim().isNotEmpty &&
        proteinController.text.trim().isNotEmpty &&
        carbsController.text.trim().isNotEmpty &&
        fatController.text.trim().isNotEmpty;

    setState(() {
      isButtonEnabled = isFilled;
    });
  }

  void saveFood() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('custom_foods')
        .add({
      'name': nameController.text.trim(),
      'calories': double.tryParse(caloriesController.text.trim()) ?? 0,
      'protein': double.tryParse(proteinController.text.trim()) ?? 0,
      'carbs': double.tryParse(carbsController.text.trim()) ?? 0,
      'fat': double.tryParse(fatController.text.trim()) ?? 0,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Get.back();
    Get.snackbar("Added", "Custom food item added!",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  void dispose() {
    nameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Custom Food")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Food Name")),
            TextField(controller: caloriesController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Calories")),
            TextField(controller: proteinController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Protein (g)")),
            TextField(controller: carbsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Carbs (g)")),
            TextField(controller: fatController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Fat (g)")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isButtonEnabled ? saveFood : null,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
