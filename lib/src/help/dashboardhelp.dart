// lib/src/features/core/screens/help/dashboard_help_screen.dart

import 'package:flutter/material.dart';

class DashboardHelpScreen extends StatelessWidget {
  const DashboardHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How to Use Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
🔹 The Dashboard shows your daily calorie progress in a circular indicator.

🔹 Tap the circular chart to view and edit today's food log.

🔹 Macronutrient totals (Protein, Fats, Carbs) are shown beneath the chart.

🔹 Use the "Edit Daily Calorie Limit" button to update your calorie goal.

🔹 Tap "Calculate Maintenance Calories" if you're unsure of your target.

🔹 A pie chart below gives you a breakdown of your macros.

            ''',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}
