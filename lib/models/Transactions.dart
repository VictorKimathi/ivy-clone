import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  String id;
  String accountId;
  double amount;
  String type; // 'expense' or 'income'
  String categoryId;
  DateTime date;

  Transaction({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
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

  // Save transaction to Firestore
  Future<void> save() async {
    await FirebaseFirestore.instance.collection('transactions').doc(id).set(toMap());
  }

  // Fetch all transactions for an account
  static Future<List<Transaction>> getTransactionsByAccount(String accountId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('accountId', isEqualTo: accountId)
        .get();
    return snapshot.docs.map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  // Fetch transactions by category
  static Future<List<Transaction>> getTransactionsByCategory(String categoryId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return snapshot.docs.map((doc) => Transaction.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}