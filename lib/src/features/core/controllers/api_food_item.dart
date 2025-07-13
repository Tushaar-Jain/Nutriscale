import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutriscale/src/features/core/models/food_item.dart';

Future<List<FoodItem>> fetchFoodItems(String query) async {
  const apiKey = 'iAonQ2vL4DHgdV81G4PwZg==DzKdr5YReKUBlVag'; 
  final url = Uri.parse('https://api.calorieninjas.com/v1/nutrition?query=$query');

  final response = await http.get(
    url,
    headers: {'X-Api-Key': apiKey},
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final List items = jsonData['items'];
    return items.map((item) => FoodItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load food data');
  }
}
