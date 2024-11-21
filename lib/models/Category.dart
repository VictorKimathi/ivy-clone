import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id;
  String name;

  Category({required this.id, required this.name});

  // Convert to Firebase document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create Category object from Firebase document
  static Category fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }

  // Save category to Firestore
  Future<void> save() async {
    await FirebaseFirestore.instance.collection('categories').doc(id).set(toMap());
  }

  // Fetch all categories
  static Future<List<Category>> getAllCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}