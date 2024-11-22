import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ivywallet/components/TransactionSummary.dart';
import 'DateSelectorPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> transactions = [];
  double totalAmount = 0.0;
  double totalIncome = 0.0; // Total income
  double totalExpense = 0.0; // Total expenses

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('transactions').get();

      final fetchedTransactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'date': data['date'] ?? 'Unknown Date',
          'amount': (data['amount'] as num?)?.toDouble() ?? 0.0,
          'type': data['type'] ?? 'Unknown Type',
        };
      }).toList();

      // Calculate totals
      double computedTotal = 0.0;
      double computedIncome = 0.0;
      double computedExpense = 0.0;

      for (var transaction in fetchedTransactions) {
        final amount = transaction['amount'];
        if (transaction['type'] == 'income') {
          computedIncome += amount;
        } else if (transaction['type'] == 'expense') {
          computedExpense += amount;
        }
        computedTotal += amount;
      }

      setState(() {
        transactions = fetchedTransactions;
        totalAmount = computedTotal;
        totalIncome = computedIncome;
        totalExpense = computedExpense;
      });
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinanceAI'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DateSelectorPage()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.black),
                  SizedBox(width: 4),
                  Text(
                    "November",
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KES ${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        isScrollControlled: true,
                        builder: (_) => TransactionSummary(type: 'income'),
                      );
                    },
                    child: Card(
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.arrow_downward, color: Colors.white),
                            SizedBox(height: 8),
                            Text('Income', style: TextStyle(color: Colors.white, fontSize: 16)),
                            SizedBox(height: 4),
                            Text(
                              '${totalIncome.toStringAsFixed(2)} KES',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        isScrollControlled: true,
                        builder: (_) => TransactionSummary(type: 'expense'),
                      );
                    },
                    child: Card(
                      color: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.arrow_upward, color: Colors.white),
                            SizedBox(height: 8),
                            Text('Expenses', style: TextStyle(color: Colors.white, fontSize: 16)),
                            SizedBox(height: 4),
                            Text(
                              '${totalExpense.toStringAsFixed(2)} KES',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Recent Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: transactions.isEmpty
                  ? Center(child: Text('No transactions available'))
                  : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text('${transaction['type']} - KES ${transaction['amount'].toStringAsFixed(2)}'),
                      subtitle: Text(transaction['date']),
                      tileColor: transaction['amount'] >= 0 ? Colors.green[50] : Colors.red[50],
                      leading: CircleAvatar(
                        child: Icon(
                          transaction['amount'] >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
                          color: transaction['amount'] >= 0 ? Colors.green : Colors.red,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
