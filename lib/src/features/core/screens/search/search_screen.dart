import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/features/core/controllers/api_food_item.dart';
import 'package:nutriscale/src/features/core/controllers/calorie_controller.dart';
import 'package:nutriscale/src/features/core/models/food_item.dart';
import 'package:nutriscale/src/features/core/screens/search/custom_food.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final calorieController = Get.put(CalorieController());

  final _controller = TextEditingController();
  List<FoodItem> _results = [];
  bool _isLoading = false;
  String? _error;

  void _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _results = [];
    });

    try {
      final data = await fetchFoodItems(query);
      setState(() {
        _results = data;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Food',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryAppColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => CustomFoodScreen());
                },
                icon: const Icon(Icons.fastfood,color: appBlack,),
                label: Text(
                  "My Custom Food",
                  style: TextStyle(
                    color: isDark ? secondaryAppColor : appBlack,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryAppColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter food name (e.g., "10g rice")...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: (_) => _search(),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 8),
            Text(
              "Mention the food weight at the start in grams",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            Text(
              "Example: 10g rice, 25g dal",
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? Center(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : _results.isEmpty
                      ? const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                      : ListView.separated(
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          return Card(
                            elevation: 3,
                            color: isDark ? Colors.grey[850] : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                'Calories: ${item.calories.toStringAsFixed(1)} kcal\n'
                                'Protein: ${item.protein}g | Carbs: ${item.carbs}g | Fat: ${item.fat}g',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                  size: 28,
                                ),
                                onPressed: () {
                                  calorieController.addFoodItem(item);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${item.name} added!"),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
