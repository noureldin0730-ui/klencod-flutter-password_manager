import 'package:flutter/material.dart';
import '../models/password_entry.dart';
import '../services/database_helper.dart';
import 'add_password_screen.dart';
import 'view_password_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PasswordEntry> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final data = await DatabaseHelper.instance.getAll();
    setState(() => _passwords = data);
  }

  Future<void> _delete(int id) async {
    await DatabaseHelper.instance.delete(id);
    _loadPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خزنة الباسوردات'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: _passwords.isEmpty
                ? const Center(child: Text('لا توجد كلمات مرور محفوظة'))
                : ListView.builder(
                    itemCount: _passwords.length,
                    itemBuilder: (context, index) {
                      final pwd = _passwords[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.lock, color: Colors.white)),
                          title: Text(pwd.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(pwd.username),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(pwd.id!),
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
          // تذييل الحقوق بخط خفيف
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              'الحقوق محفوظة © 2026 Nour',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPasswordScreen()),
          );
          if (added == true) _loadPasswords();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}