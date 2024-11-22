import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../pages/Account.dart';

class Transaction {
  String id;
  String accountId;
  double amount;
  String type; // 'expense' or 'income'
  String categoryId;
  DateTime date;
  Account? account; // This will hold the account information

  Transaction({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.account, // Optional: when constructing, it may not be available yet
  });

  // Convert to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'amount': amount,
      'type': type,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
    };
  }

  // Create Transaction object from Firebase document
  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      accountId: map['accountId'],
      amount: map['amount'],
      type: map['type'],
      categoryId: map['categoryId'],
      date: DateTime.parse(map['date']),
    );
  }

  // Fetch account information for the transaction
  Future<void> fetchAccount() async {
    account = await Account.getAccountById(accountId);
  }

  // Save transaction to Firestore
  Future<void> save() async {
    await FirebaseFirestore.instance.collection('transactions').doc(id).set(
        toMap());
  }

  // Fetch all transactions for an account (with account details)
  static Future<List<Transaction>> getTransactionsByAccount(
      String accountId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('accountId', isEqualTo: accountId)
        .get();

    // Convert documents to Transaction objects and fetch account details
    List<Transaction> transactions = snapshot.docs.map((doc) {
      Transaction transaction = Transaction.fromMap(
          doc.data() as Map<String, dynamic>);
      transaction.fetchAccount(); // Fetch account details asynchronously
      return transaction;
    }).toList();

    return transactions;
  }

  // Fetch transactions by category (with account details)
  static Future<List<Transaction>> getTransactionsByCategory(
      String categoryId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    // Convert documents to Transaction objects and fetch account details
    List<Transaction> transactions = snapshot.docs.map((doc) {
      Transaction transaction = Transaction.fromMap(
          doc.data() as Map<String, dynamic>);
      transaction.fetchAccount(); // Fetch account details asynchronously
      return transaction;
    }).toList();

    return transactions;
  }

  static Future<List<Transaction>> getTransactionsByType(String type) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('type', isEqualTo: type)
          .get();

      print("Fetched ${snapshot.docs.length} transactions for type: $type");

      return snapshot.docs
          .map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching transactions: $e");
      }
      return [];
    }
  }
}