import 'package:flutter/material.dart';
import '../services/crypto_service.dart';

class ViewPasswordScreen extends StatefulWidget {
  final String encryptedPassword;
  final String iv;
  const ViewPasswordScreen({super.key, required this.encryptedPassword, required this.iv});

  @override
  State<ViewPasswordScreen> createState() => _ViewPasswordScreenState();
}

class _ViewPasswordScreenState extends State<ViewPasswordScreen> {
  String _decrypted = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _decrypt();
  }

  Future<void> _decrypt() async {
    final pwd = await CryptoService.decrypt(widget.encryptedPassword, widget.iv);
    setState(() {
      _decrypted = pwd;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('كلمة المرور')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('كلمة المرور الخاصة بك:', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  SelectableText(
                    _decrypted,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
      ),
    );
  }
}