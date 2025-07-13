import 'package:flutter/material.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:nutriscale/src/features/core/screens/maintain_cal/calorie_calculator.dart';
import 'package:nutriscale/src/features/core/screens/maintain_cal/calorie_result_box.dart';

class MaintainCal extends StatefulWidget {
  const MaintainCal({Key? key}) : super(key: key);

  @override
  State<MaintainCal> createState() => _MaintainCalState();
}

class _MaintainCalState extends State<MaintainCal> {
  final _formKey = GlobalKey<FormState>();

  final ageController = TextEditingController(text: '22');
  final heightCmController = TextEditingController(text: '180');
  final heightFeetController = TextEditingController(text: '5');
  final heightInchController = TextEditingController(text: '11');
  final weightController = TextEditingController(text: '65');

  String gender = 'm';
  double activity = 1.2;
  String result = '';
  bool useFeet = false;

  double? _totalCalories;
  double? _deficitCalories;
  double? _surplusCalories;

  void calculateCalories() {
    if (!_formKey.currentState!.validate()) return;

    final age = int.parse(ageController.text);
    final weight = double.parse(weightController.text);

    double height;

    if (useFeet) {
      final feet = double.tryParse(heightFeetController.text) ?? 0;
      final inch = double.tryParse(heightInchController.text) ?? 0;
      height = CalorieCalculator.cmFromFeetInches(feet, inch); // convert to cm
    } else {
      height = double.parse(heightCmController.text);
    }

    double bmr;
    bmr = CalorieCalculator.calculateBMR(
      age: age,
      weight: weight,
      height: height,
      gender: gender,
    );

    _totalCalories = bmr * activity;
    _deficitCalories = _totalCalories! * 0.9;
    _surplusCalories = _totalCalories! * 1.15;

    setState(() {
      result = 'calculated';
    });
  }

  void clearFields() {
    ageController.text = '22';
    heightCmController.text = '180';
    heightFeetController.text = '5';
    heightInchController.text = '11';
    weightController.text = '65';
    gender = 'm';
    activity = 1.2;
    _totalCalories = null;
    _deficitCalories = null;
    _surplusCalories = null;
    setState(() {
      result = '';
    });
  }

  @override
  void dispose() {
    ageController.dispose();
    heightCmController.dispose();
    heightFeetController.dispose();
    heightInchController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
      filled: true,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Maintenance Calories Calculator'),
          backgroundColor: primaryAppColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: ageController,
                  decoration: inputDecoration.copyWith(labelText: 'Age (15-80)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final age = int.tryParse(value ?? '');
                    if (age == null || age < 15 || age > 80) {
                      return 'Enter valid age between 15 and 80';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
      
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        activeColor: primaryAppColor,
                        title: const Text('Male'),
                        value: 'm',
                        groupValue: gender,
                        onChanged: (val) => setState(() => gender = val!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        activeColor: primaryAppColor,
                        title: const Text('Female'),
                        value: 'f',
                        groupValue: gender,
                        onChanged: (val) => setState(() => gender = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
      
                Row(
                  children: [
                    Text('Use Feet/Inches', style: TextStyle(fontSize: 16)),
                    Switch(
                      activeColor: primaryAppColor,
                      value: useFeet,
                      onChanged: (val) {
                        setState(() {
                          useFeet = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
      
                if (useFeet)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: heightFeetController,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Height (ft)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final val = double.tryParse(value ?? '');
                            if (val == null || val <= 0) {
                              return 'Enter valid feet';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: heightInchController,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Height (in)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final val = double.tryParse(value ?? '');
                            if (val == null || val < 0 || val >= 12) {
                              return '0-11 inches';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                else
                  TextFormField(
                    controller: heightCmController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Height (cm)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final height = double.tryParse(value ?? '');
                      if (height == null || height <= 0) {
                        return 'Enter valid height';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 15),
      
                TextFormField(
                  controller: weightController,
                  decoration: inputDecoration.copyWith(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final weight = double.tryParse(value ?? '');
                    if (weight == null || weight <= 0) {
                      return 'Enter valid weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
      
                DropdownButtonFormField<double>(
                  value: activity,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Activity Level',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 1.2,
                      child: Text('Sedentary (little or no exercise)'),
                    ),
                    DropdownMenuItem(
                      value: 1.375,
                      child: Text('Light (exercise 1–3 days/week)'),
                    ),
                    DropdownMenuItem(
                      value: 1.55,
                      child: Text('Moderate (3–5 days/week)'),
                    ),
                    DropdownMenuItem(
                      value: 1.725,
                      child: Text('Active (daily exercise)'),
                    ),
                    DropdownMenuItem(
                      value: 1.9,
                      child: Text('Very Active (hard exercise/job)'),
                    ),
                  ],
                  onChanged: (val) => setState(() => activity = val!),
                ),
                const SizedBox(height: 30),
      
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: calculateCalories,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryAppColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Calculate',
                          style: TextStyle(
                            color: isDark ? secondaryAppColor : appBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: clearFields,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryAppColor.shade200,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: isDark ? secondaryAppColor : appBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
      
                if (result.isNotEmpty && _totalCalories != null)
                  CalorieResultBox(
                    total: _totalCalories!,
                    deficit: _deficitCalories!,
                    surplus: _surplusCalories!,
                    isDark: isDark,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
