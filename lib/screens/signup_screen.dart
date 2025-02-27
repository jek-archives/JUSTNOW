import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import SharedPreferences
import '../widgets/custom_text_field.dart';
import '../widgets/password_text_field.dart';
import '../utils/gradient_background.dart';
import '../widgets/logo_widget.dart';
import 'email_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorText;
  String? _emailErrorText;

  bool _isValidPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasMinLength = password.length >= 6;
    return hasUppercase && hasLowercase && hasNumber && hasMinLength;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email);
  }

  void _validateInputs() {
    setState(() {
      if (!_isValidEmail(_emailController.text)) {
        _emailErrorText = "Enter a valid Gmail address.";
      } else {
        _emailErrorText = null;
      }

      if (!_isValidPassword(_passwordController.text)) {
        _errorText =
            "Password must be at least 6 characters, include uppercase, lowercase, and a number.";
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _errorText = "Passwords do not match!";
      } else {
        _errorText = null;
      }
    });
  }

  Future<void> _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      // Navigate to Email Verification Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message; // Set error message if signup fails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          // Enable scrolling to prevent overflow
          child: Container(
            height: MediaQuery.of(context).size.height, // Ensure full height
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LogoWidget(),
                    const SizedBox(height: 20),
                    const Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            label: "Email",
                          ),
                          if (_emailErrorText != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _emailErrorText!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 12),
                          PasswordTextField(
                            label: "Password",
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 12),
                          PasswordTextField(
                            label: "Confirm Password",
                            controller: _confirmPasswordController,
                          ),
                          if (_errorText != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _errorText!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _validateInputs();
                              if (_errorText == null &&
                                  _emailErrorText == null) {
                                _signUp(); // Proceed with sign-up logic
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade300,
                              minimumSize: const Size(double.infinity, 45),
                            ),
                            child: const Text("Get Started!",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        size: 24, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
