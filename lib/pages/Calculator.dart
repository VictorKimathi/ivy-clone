import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';



class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayText = '0';

  void _updateDisplay(String value) {
    setState(() {
      if (value == "=") {
        try {
          _displayText = _evaluateExpression(_displayText);
        } catch (e) {
          _displayText = "Error";
        }
      } else if (_displayText == '0' && value != '.' && value != 'C') {
        _displayText = value;
      } else {
        _displayText += value;
      }
    });
  }

  void _clearDisplay() {
    setState(() {
      _displayText = '0';
    });
  }

  String _evaluateExpression(String expression) {
    try {
      final parser = Parser();
      final exp = parser.parse(expression.replaceAll('x', '*').replaceAll('÷', '/'));
      final contextModel = ContextModel();
      final result = exp.evaluate(EvaluationType.REAL, contextModel);
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          // Display the current value
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  _displayText,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Calculator(
              onButtonPressed: _updateDisplay,
              onClearPressed: _clearDisplay,
            ),
          ),
        ],
      ),
    );
  }
}

class Calculator extends StatelessWidget {
  final List<String> buttons = [
    '7', '8', '9', 'C',
    '4', '5', '6', '÷',
    '1', '2', '3', 'x',
    '0', '.', '=', '-',
    '+'
  ];

  final Function(String) onButtonPressed;
  final VoidCallback onClearPressed;

Calculator({
    Key? key,
    required this.onButtonPressed,
    required this.onClearPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              if (buttons[index] == 'C') {
                onClearPressed();
              } else {
                onButtonPressed(buttons[index]);
              }
            },
            child: Text(
              buttons[index],
              style: const TextStyle(fontSize: 24),
            ),
          );
        },
      ),
    );
  }
}
