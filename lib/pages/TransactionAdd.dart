import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String amount = "0";

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'clear') {
        amount = "0";
      } else if (value == '.' && !amount.contains('.')) {
        amount += value;
      } else if (value == 'back') {
        amount = amount.length > 1 ? amount.substring(0, amount.length - 1) : "0";
      } else if (value != '.' && value != 'back' && value != 'clear') {
        if (amount == "0") {
          amount = value;
        } else {
          amount += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Button Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  accountButton('Mpesa', selected: false),
                  accountButton('Equity', selected: true),
                  accountButton('Mobile', selected: false),
                ],
              ),
            ),

            // Amount Display
            Expanded(
              child: Center(
                child: Text(
                  "$amount KES",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Number Pad
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (var i = 1; i <= 9; i++)
                  numberButton(i.toString(), onButtonPressed),
                numberButton('.', onButtonPressed),
                numberButton('0', onButtonPressed),
                actionButton(Icons.backspace, 'back', onButtonPressed),
              ],
            ),

            // Bottom Action Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bottomActionButton(Icons.close, 'Cancel', onButtonPressed),
                  IconButton(
                    icon: Icon(Icons.calculate, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculatorScreen(),
                        ),
                      );
                    },
                  ),
                  bottomActionButton(Icons.check, 'Enter', onButtonPressed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountButton(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget numberButton(String label, Function(String) onPressed) {
    return GestureDetector(
      onTap: () => onPressed(label),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, String action, Function(String) onPressed) {
    return GestureDetector(
      onTap: () => onPressed(action),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red[50],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget bottomActionButton(IconData icon, String action, Function(String) onPressed) {
    return GestureDetector(
      onTap: () => onPressed(action),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: action == 'Enter' ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: action == 'Enter' ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 5),
            Text(
              action,
              style: TextStyle(
                color: action == 'Enter' ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define CalculatorScreen
class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Center(
        child: CalculatorScreen(),
      ),
    );
  }
}
