import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MaterialApp(
    home: ZakatCalculationPage(),
  ));
}

class ZakatCalculationPage extends StatefulWidget {
  const ZakatCalculationPage({super.key});

  @override
  _ZakatCalculationPageState createState() => _ZakatCalculationPageState();
}

class _ZakatCalculationPageState extends State<ZakatCalculationPage> {
  final TextEditingController _quantityController = TextEditingController();
  double _zakatAmount = 0.0;
  String _waterType = 'rain';

  // Calculator Variables
  String _expression = '';
  String _result = '0';

  void _calculateZakat() {
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    if (quantity <= 0) {
      setState(() {
        _zakatAmount = 0.0;
      });
      return;
    }

    // Calculate Zakat based on water type
    if (_waterType == 'rain') {
      _zakatAmount = quantity * 0.10; // 10% Zakat for rainwater
    } else if (_waterType == 'irrigation') {
      _zakatAmount = quantity * 0.05; // 5% Zakat for irrigation
    } else if (_waterType == 'equal') {
      _zakatAmount = quantity * 0.075; // 7.5% Zakat for equal usage
    }

    setState(() {});
  }

  // Calculator Functions
  void _onDigitPress(String text) {
    setState(() {
      _expression += text;
    });
  }

  void _onClear() {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _onCalculate() {
    try {
      Parser parser = Parser();
      Expression expression = parser.parse(_expression);
      ContextModel contextModel = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        _result = eval.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('যাকাত গণনা'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zakat Calculation Section
              const Text(
                'আপনার ফসলের পরিমাণ (কেজি):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'কেজিতে পরিমাণ লিখুন',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'পানির উৎস নির্বাচন করুন:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _buildWaterSourceTiles(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateZakat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text('যাকাত গণনা করুন'),
              ),
              const SizedBox(height: 20),
              const Text(
                'আপনার যাকাতের পরিমাণ:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '৳ ${_zakatAmount.toStringAsFixed(2)} কেজি',
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
              const SizedBox(height: 40),

              // Calculator Section
              const Divider(),
              const Text(
                'ক্যালকুলেটর',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                alignment:
                    Alignment.topRight, // Align the text to the top right
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8), // Reduced vertical padding
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _expression,
                  style: const TextStyle(fontSize: 28, color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment:
                    Alignment.topRight, // Align the text to the top right
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8), // Reduced vertical padding
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _result,
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: screenWidth < 400 ? 3 : 4,
                shrinkWrap: true,
                childAspectRatio: 1.6,
                padding: const EdgeInsets.all(8),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _buildCalculatorButton('1'),
                  _buildCalculatorButton('2'),
                  _buildCalculatorButton('3'),
                  _buildCalculatorButton('4'),
                  _buildCalculatorButton('5'),
                  _buildCalculatorButton('6'),
                  _buildCalculatorButton('7'),
                  _buildCalculatorButton('8'),
                  _buildCalculatorButton('9'),
                  _buildCalculatorButton('.'),
                  _buildCalculatorButton('/'),
                  _buildCalculatorButton('+'),
                  _buildCalculatorButton('0'),
                  _buildCalculatorButton('*'),
                  _buildCalculatorButton('-'),
                  _buildCalculatorButton('C'),
                  _buildCalculatorButton('00'),
                  _buildCalculatorButton('='),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWaterSourceTiles() {
    return [
      RadioListTile(
        title: const Text('বৃষ্টির পানি'),
        value: 'rain',
        groupValue: _waterType,
        onChanged: (value) {
          setState(() {
            _waterType = value.toString();
          });
        },
      ),
      RadioListTile(
        title: const Text('সেচের পানি'),
        value: 'irrigation',
        groupValue: _waterType,
        onChanged: (value) {
          setState(() {
            _waterType = value.toString();
          });
        },
      ),
      RadioListTile(
        title: const Text('উভয় সমান'),
        value: 'equal',
        groupValue: _waterType,
        onChanged: (value) {
          setState(() {
            _waterType = value.toString();
          });
        },
      ),
    ];
  }

  Widget _buildCalculatorButton(String label) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'C') {
          _onClear();
        } else if (label == '=') {
          _onCalculate();
        } else {
          _onDigitPress(label);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 24)),
    );
  }
}
