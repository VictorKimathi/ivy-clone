import 'package:flutter/material.dart';

import '../models/Settings.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransactionPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Text(
              'Accounts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                BalanceSummary(
                  title: 'Total Balance',
                  amount: '0.00 KES',
                ),
                BalanceSummary(
                  title: 'Total Balance (excluded)',
                  amount: '0.00 KES',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Account Cards
            AccountCard(
              color: Colors.teal,
              accountName: 'Mpesa',
              balance: '0.00 KES',
              income: '0.00 KES',
              expenses: '0.00 KES',
            ),
            const SizedBox(height: 16),
            AccountCard(
              color: Colors.lightBlue,
              accountName: 'Equity',
              balance: '0.00 KES',
              income: '0.00 KES',
              expenses: '0.00 KES',
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceSummary extends StatelessWidget {
  final String title;
  final String amount;

  const BalanceSummary({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class AccountCard extends StatelessWidget {
  final Color color;
  final String accountName;
  final String balance;
  final String income;
  final String expenses;

  const AccountCard({
    super.key,
    required this.color,
    required this.accountName,
    required this.balance,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              accountName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              balance,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AccountDetail(
                  label: 'INCOME THIS MONTH',
                  amount: income,
                ),
                AccountDetail(
                  label: 'EXPENSES THIS MONTH',
                  amount: expenses,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccountDetail extends StatelessWidget {
  final String label;
  final String amount;

  const AccountDetail({super.key, required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}