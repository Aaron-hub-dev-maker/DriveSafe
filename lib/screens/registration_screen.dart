import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _licenseController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required. Please fill in all fields.';
      });
      return false;
    }
    return true;
  }

  void _registerUser() async {
    if (!_validateFields()) return;

    bool success = await _authService.register(
      _usernameController.text,
      _emailController.text,
      _firstNameController.text,
      _lastNameController.text,
      _passwordController.text,
      _licenseController.text,
      _phoneController.text,
    );

    if (success) {
      // ✅ Navigate back to login after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Registration failed. Username may already exist.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Username", _usernameController),
              _buildTextField("Email", _emailController),
              _buildTextField("First Name", _firstNameController),
              _buildTextField("Last Name", _lastNameController),
              _buildTextField("Phone Number", _phoneController),
              _buildTextField(
                "Password",
                _passwordController,
                isPassword: true,
              ),
              _buildTextField("Driver’s License Number", _licenseController),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _registerUser,
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
