import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BMICalculator(),
    debugShowCheckedModeBanner: false,
  ));
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final _formKey = GlobalKey<FormState>();
  double height = 0.0;
  double weight = 0.0;
  double bmi = 0.0;
  double protein = 0.0;
  double carbohydrate = 0.0;
  double sneho = 0.0;
  int? age; // Optional age

  void calculateBMI() {
    setState(() {
      if (height > 0 && weight > 0) {
        bmi = weight / ((height / 100) * (height / 100));

        // Calculate nutritional requirements based on BMI and age
        if (age == null) {
          // Default calculations if age is not provided
          if (bmi < 24.9) {
            carbohydrate = bmi * 28;
            protein = bmi * 8;
            sneho = bmi * 8;
          } else if (bmi >= 24.9 && bmi < 29.9) {
            carbohydrate = bmi * 24;
            protein = bmi * 7;
            sneho = bmi * 7;
          } else if (bmi >= 30) {
            carbohydrate = bmi * 22;
            protein = bmi * 6.5;
            sneho = bmi * 6;
          }
        } else if (age! >= 6 && age! <= 15) {
          carbohydrate = bmi * 24;
          protein = bmi * 8;
          sneho = bmi * 8;
        } else if (age! > 15 && age! <= 50) {
          carbohydrate = bmi * 28;
          protein = bmi * 8;
          sneho = bmi * 8;
        } else if (age! > 50) {
          carbohydrate = bmi * 22;
          protein = bmi * 6.5;
          sneho = bmi * 6;
        }
      }
    });
  }

  String getBMICategory() {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('BMI Calculator')),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreenAccent, Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter your details:',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  _buildTextField('Height (cm):', (value) {
                    height = double.tryParse(value) ?? 0.0;
                  }),
                  const SizedBox(height: 20),
                  _buildTextField('Weight (kg):', (value) {
                    weight = double.tryParse(value) ?? 0.0;
                  }),
                  const SizedBox(height: 20),
                  _buildTextField('Age (optional):', (value) {
                    age = value.isNotEmpty ? int.tryParse(value) : null;
                  }),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          calculateBMI();
                          _showResultsDialog();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Calculate',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          validator: (value) {
            if (label != 'Age (optional):' &&
                (value == null || value.isEmpty)) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('BMI Results'),
          content: Text(
            'BMI: ${bmi.toStringAsFixed(2)}\n'
            'Category: ${getBMICategory()}\n'
            'Carbohydrate: ${carbohydrate.toStringAsFixed(2)} g\n'
            'Protein: ${protein.toStringAsFixed(2)} g\n'
            'Sneho: ${sneho.toStringAsFixed(2)} g',
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}
