import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spaceBetween,
    this.textAlign,
  });

  final String image, title, subtitle;
  final CrossAxisAlignment crossAxisAlignment;
  final double? spaceBetween;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(image: AssetImage(image), height: size.height * 0.2),
        SizedBox(height: spaceBetween),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        Text(subtitle, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
