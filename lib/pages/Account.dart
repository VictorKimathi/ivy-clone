import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name; // Name of the account holder or account
  double balance;

  Account({
    required this.id,
    required this.name,
    required this.balance,
  });

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

  // Fetch account from Firestore by account ID
  static Future<Account?> getAccountById(String accountId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(accountId)
        .get();

    if (snapshot.exists) {
      return Account.fromMap(snapshot.data() as Map<String, dynamic>);
    } else {
      return null; // Account not found
    }
  }
}
