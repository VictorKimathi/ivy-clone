import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String transactionType; // Add this field to accept the transaction type
  PaymentScreen({Key? key, required this.transactionType}) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String amount = "0";
  String? selectedAccount;
  late String transactionType; // Default type
  @override
  void initState() {
    super.initState();
    // Initialize transactionType from the constructor
    transactionType = widget.transactionType;
    // Log the transactionType to the console
    print("Transaction type: $transactionType");
  }
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

  Future<void> saveTransaction() async {
    if (double.tryParse(amount) != null && double.parse(amount) > 0 && selectedAccount != null) {
      try {
        await FirebaseFirestore.instance.collection('transactions').add({
          'amount': double.parse(amount),
          'timestamp': FieldValue.serverTimestamp(),
          'type': transactionType,
          'account': selectedAccount,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Transaction saved")));
        setState(() {
          amount = "0"; // Reset amount
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving transaction: $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a valid amount and select an account")));
    }
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
          'Transaction',
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
            // Account Selector
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('accounts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No accounts available.'));
                }

                var accountDocs = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: accountDocs.map((doc) {
                      String accountName = doc['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAccount = accountName;
                          });
                        },
                        child: accountButton(accountName, selected: selectedAccount == accountName),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            // Transaction Type Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                transactionTypeButton('Income', transactionType == 'income'),
                transactionTypeButton('Expense', transactionType == 'expense'),
              ],
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
                  bottomActionButton(Icons.close, 'Cancel', () {
                    setState(() {
                      amount = "0";
                      selectedAccount = null;
                    });
                  }),
                  GestureDetector(
                    onTap: saveTransaction,
                    child: bottomActionButton(Icons.check, 'Enter', null),
                  ),
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

  Widget transactionTypeButton(String label, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          transactionType = label.toLowerCase();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
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

  Widget bottomActionButton(IconData icon, String label, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: label == 'Enter' ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: label == 'Enter' ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: label == 'Enter' ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
