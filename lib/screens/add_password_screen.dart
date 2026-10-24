import 'package:flutter/material.dart';
import '../models/password_entry.dart';
import '../services/crypto_service.dart';
import '../services/database_helper.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final encryptedData = await CryptoService.encrypt(_passwordCtrl.text.trim());
    final entry = PasswordEntry(
      title: _titleCtrl.text.trim(),
      username: _usernameCtrl.text.trim(),
      encryptedPassword: encryptedData['encryptedPassword']!,
      iv: encryptedData['iv']!,
    );
    await DatabaseHelper.instance.insert(entry);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة كلمة مرور')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'اسم الموقع/التطبيق', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(labelText: 'اسم المستخدم', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('حفظ مشفر'),
                style: FilledButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.all(16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}