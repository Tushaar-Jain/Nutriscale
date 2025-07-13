import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/features/core/controllers/bottom_nav_controller.dart';
import 'package:nutriscale/src/features/core/controllers/calorie_controller.dart';
import 'package:nutriscale/src/features/core/screens/dashboard/edit_calorie_goal_dialog.dart';
import 'package:nutriscale/src/features/core/screens/dashboard/reset_calorie_screen.dart';
import 'package:nutriscale/src/help/common_help_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final calorieController = Get.put(CalorieController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(
            color: isDark ? secondaryAppColor : appBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? secondaryAppColor : appBlack,
            ),
            onSelected: (value) {
              if (value == 'About') {
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: Text('About'),
                        content: Text(
                          'NutriScale is a calorie and nutrition tracking application developed as part of a college project. Designed with both functionality and user experience in mind, NutriScale helps users track their daily calorie intake, monitor macronutrients, and maintain a balanced diet—especially focused on Indian cuisine.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                );
              } else if (value == 'Help') {
                showCommonHelpDialog(context);

              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: 'About', child: Text('About')),
                  PopupMenuItem(value: 'Help', child: Text('Help')),
                ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// --- Calorie Speedometer ---
              Obx(() {
                final progress = calorieController.progress.clamp(0.0, 1.0);
                final totalCalories = calorieController.totalCalories.value;
                final goal = calorieController.calorieGoal.value.toInt();

                return GestureDetector(
                  onTap: () => Get.to(() => ResetCalorieScreen()),
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 90,
                        lineWidth: 18,
                        percent: progress,
                        progressColor: Colors.orange,
                        backgroundColor: Colors.orange.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${totalCalories.toStringAsFixed(0)} Kcal",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "of $goal kcal",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tap to view today's log",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// --- Macronutrient Summary ---
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MacroStat(
                          title: "Protein",
                          value:
                              "${calorieController.totalProtein.value.toStringAsFixed(1)}g",
                          tooltip: "Recommended: 0.8g/kg body weight",
                        ),
                        _MacroStat(
                          title: "Fats",
                          value:
                              "${calorieController.totalFat.value.toStringAsFixed(1)}g",
                        ),
                        _MacroStat(
                          title: "Carbs",
                          value:
                              "${calorieController.totalCarbs.value.toStringAsFixed(1)}g",
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// --- Edit Daily Limit Button ---
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                  color: secondaryAppColor,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryAppColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditCalorieGoalDialog(),
                  );
                },
                label: Text(
                  "Edit Daily Calorie Limit",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? secondaryAppColor : appBlack,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// --- Maintenance Advice ---
              Text(
                "If you don't know your maintenance calories, use the calculator below:",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),

              /// --- Maintenance Navigation ---
              TextButton.icon(
                icon: const Icon(Icons.calculate),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Get.find<BottomNavController>().changeTab(2),
                label: const Text(
                  "Calculate Maintenance Calories",
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// --- Pie Chart Section ---
              const Center(
                child: Text(
                  "Macronutrient Breakdown",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                final protein = calorieController.totalProtein.value;
                final carbs = calorieController.totalCarbs.value;
                final fat = calorieController.totalFat.value;

                final dataMap = <String, double>{
                  "Protein": protein,
                  "Carbs": carbs,
                  "Fats": fat,
                };

                return PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartRadius: MediaQuery.of(context).size.width / 2,
                  colorList: [
                    Colors.lightGreen.shade400,
                    Colors.yellow.shade600,
                    Colors.orange.shade400,
                  ],
                  chartType: ChartType.disc,
                  ringStrokeWidth: 30,
                  legendOptions: const LegendOptions(
                    legendPosition: LegendPosition.top,
                    showLegendsInRow: true,
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true,
                    showChartValueBackground: false,
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroStat extends StatelessWidget {
  final String title;
  final String value;
  final String? tooltip;
  const _MacroStat({required this.title, required this.value, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}
