import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordEntry {
  final String? id;
  final String title;
  final String username;
  final String encryptedPassword;
  final String iv;

  PasswordEntry({
    this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
    required this.iv,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'username': username,
      'encryptedPassword': encryptedPassword,
      'iv': iv,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory PasswordEntry.fromMap(String id, Map<String, dynamic> map) {
    return PasswordEntry(
      id: id,
      title: map['title'] ?? '',
      username: map['username'] ?? '',
      encryptedPassword: map['encryptedPassword'] ?? '',
      iv: map['iv'] ?? '',
    );
  }
}