import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/password_entry.dart';
import '../services/database_helper.dart';
import 'add_password_screen.dart';
import 'view_password_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خزنة الباسوردات'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PasswordEntry>>(
        stream: DatabaseHelper.instance.getPasswordsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد كلمات مرور محفوظة'));
          }

          final passwords = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: passwords.length,
                  itemBuilder: (context, index) {
                    final pwd = passwords[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.lock, color: Colors.white)),
                        title: Text(pwd.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(pwd.username),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => DatabaseHelper.instance.delete(pwd.id!),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewPasswordScreen(
                                encryptedPassword: pwd.encryptedPassword,
                                iv: pwd.iv,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'الحقوق محفوظة © 2026 Nour',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPasswordScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}