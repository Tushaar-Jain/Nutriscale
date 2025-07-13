import 'package:flutter/material.dart';

class CalorieResultBox extends StatelessWidget {
  final double total;
  final double deficit;
  final double surplus;
  final bool isDark;

  const CalorieResultBox({
    super.key,
    required this.total,
    required this.deficit,
    required this.surplus,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.local_fire_department_rounded,
                color: Colors.orange,
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 16, height: 1.5),
              children: [
                const TextSpan(text: 'Your maintenance calories are '),
                TextSpan(
                  text: '${total.round()} kcal/day.\n',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: 'For a mild calorie deficit, aim for '),
                TextSpan(
                  text: '${deficit.round()} kcal/day.\n',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: 'To stay in calorie surplus, aim for '),
                TextSpan(
                  text: '${surplus.round()} kcal/day.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
