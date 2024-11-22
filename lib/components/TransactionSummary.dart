import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ivywallet/models/Transactions.dart';

class TransactionSummary extends StatelessWidget {
  final String type; // 'income' or 'expense'

  TransactionSummary({required this.type});

  Future<List<Transaction>> fetchTransactions() async {
    return await Transaction.getTransactionsByType(type);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            type == 'income' ? 'Income1' : 'Expenses',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder<List<Transaction>>(
          future: fetchTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading  transactions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No transactions found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final transaction = snapshot.data![index];
                  return ListTile(
                    title: Text(transaction.categoryId),
                    subtitle: Text(transaction.date.toIso8601String()),
                    trailing: Text(
                      'KES ${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: type == 'income' ? Colors.teal : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}