import 'package:cloud_firestore/cloud_firestore.dart';
import 'Accounts.dart';

class User {
  String id;
  String name;
  List<Account> accounts;

  User({required this.id, required this.name, this.accounts = const []});

  // Convert to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'accounts': accounts.map((account) => account.toMap()).toList(),
    };
  }

  // Create User object from Firebase document
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      accounts: (map['accounts'] as List<dynamic>)
          .map((accountMap) => Account.fromMap(accountMap as Map<String, dynamic>))
          .toList(),
    );
  }

  // Add user to Firestore
  Future<void> save() async {
    await FirebaseFirestore.instance.collection('users').doc(id).set(toMap());
  }

  // Fetch all users
  static Future<List<User>> getAllUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => User.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  // Add account to a user
  Future<void> addAccount(Account account) async {
    accounts.add(account);
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'accounts': accounts.map((account) => account.toMap()).toList(),
    });
  }
}