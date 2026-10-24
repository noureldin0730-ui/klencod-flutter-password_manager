import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/password_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  String? get _userId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> insert(PasswordEntry entry) async {
    if (_userId == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('passwords')
        .add(entry.toMap());
  }

  Stream<List<PasswordEntry>> getPasswordsStream() {
    if (_userId == null) return Stream.value([]);
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('passwords')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PasswordEntry.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> delete(String id) async {
    if (_userId == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('passwords')
        .doc(id)
        .delete();
  }
}