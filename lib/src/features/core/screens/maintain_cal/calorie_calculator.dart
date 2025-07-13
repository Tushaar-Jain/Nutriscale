class CalorieCalculator {
  static double calculateBMR({
    required int age,
    required double weight,
    required double height,
    required String gender,
  }) {
    if (gender == 'm') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  static double cmFromFeetInches(double feet, double inches) {
    return (feet * 30.48) + (inches * 2.54);
  }
}
