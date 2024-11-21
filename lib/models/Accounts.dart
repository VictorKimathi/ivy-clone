import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  double balance;

  Account({required this.id, required this.name, required this.balance});

  // Convert to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  // Create Account object from Firebase document
  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      balance: map['balance'],
    );
  }

  // Add account to Firestore
  Future<void> save() async {
    await FirebaseFirestore.instance.collection('accounts').doc(id).set(toMap());
  }

  // Update balance
  Future<void> updateBalance(double newBalance) async {
    balance = newBalance;
    await FirebaseFirestore.instance.collection('accounts').doc(id).update({'balance': balance});
  }

  // Delete account
  Future<void> delete() async {
    await FirebaseFirestore.instance.collection('accounts').doc(id).delete();
  }

  // Fetch all accounts
  static Future<List<Account>> getAllAccounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('accounts').get();
    return snapshot.docs.map((doc) => Account.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}