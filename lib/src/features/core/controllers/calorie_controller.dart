import 'package:get/get.dart';
import 'package:nutriscale/src/features/core/models/food_item.dart';

class CalorieController extends GetxController {
  var totalCalories = 0.0.obs;
  var totalProtein = 0.0.obs;
  var totalCarbs = 0.0.obs;
  var totalFat = 0.0.obs;

  var calorieGoal = 2231.0.obs;
  var addedFoodItems = <FoodItem>[].obs;

  double get progress =>
      (totalCalories.value / calorieGoal.value).clamp(0.0, 1.0);

  void setCalorieGoal(double value) {
    if (value > 0) {
      calorieGoal.value = value;
    }
  }

  void addFoodItem(FoodItem item) {
    totalCalories.value += item.calories;
    totalProtein.value += item.protein;
    totalCarbs.value += item.carbs;
    totalFat.value += item.fat;
    addedFoodItems.add(item);
  }

  void removeFoodItem(int index) {
    if (index >= 0 && index < addedFoodItems.length) {
      final item = addedFoodItems[index];
      totalCalories.value -= item.calories;
      totalProtein.value -= item.protein;
      totalCarbs.value -= item.carbs;
      totalFat.value -= item.fat;
      addedFoodItems.removeAt(index);
    }
  }

  void reset() {
    totalCalories.value = 0;
    totalProtein.value = 0;
    totalCarbs.value = 0;
    totalFat.value = 0;
    addedFoodItems.clear();
  }
}
