import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _storage = const FlutterSecureStorage();
  final _pinCtrl = TextEditingController();
  bool _isSettingUp = false;

  @override
  void initState() {
    super.initState();
    _checkIfPinExists();
  }

  Future<void> _checkIfPinExists() async {
    final pin = await _storage.read(key: 'app_pin');
    if (pin == null) {
      setState(() => _isSettingUp = true);
    }
  }

  Future<void> _handlePin() async {
    final pin = _pinCtrl.text.trim();
    if (pin.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN يجب أن يكون 4 أرقام على الأقل')));
      return;
    }

    if (_isSettingUp) {
      await _storage.write(key: 'app_pin', value: pin);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } else {
      final savedPin = await _storage.read(key: 'app_pin');
      if (pin == savedPin) {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN خطأ')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              Text(
                _isSettingUp ? 'قم بتعيين PIN لحماية تطبيقك' : 'أدخل PIN للدخول',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pinCtrl,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '****',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handlePin,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                child: Text(_isSettingUp ? 'حفظ PIN' : 'دخول'),
              ),
              const SizedBox(height: 40),
              const Text(
                'الحقوق محفوظة © 2026 Nour',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}