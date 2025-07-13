import 'package:flutter/material.dart';

class FoodSearchHelpScreen extends StatelessWidget {
  const FoodSearchHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("How to Use Food Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            '''
🔍 **Searching for Food**

- Type the name of a food item into the search bar.
- Always start with the weight in grams (e.g., **"10g rice"** or **"25g dal"**).
- Press the **search icon** or hit **Enter** to search.

✅ **Adding Food to Log**

- Each search result shows calories, protein, carbs, and fats.
- Tap the green **"+" icon** to add the item to your daily calorie log.
- A message will confirm the food was added.

🍱 **My Custom Food**

- Tap **"My Custom Food"** to view or add your own food items.
- This is useful for homemade dishes or items not in the database.

🛠 **Tips**

- If no results appear, check the spelling or try a different portion size.
- You can add multiple foods, and your calorie progress updates instantly.

💡 Example:
- Instead of "rice 10g", type **"10g rice"**.
            ''',
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        ),
      ),
    );
  }
}
