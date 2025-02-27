import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/gradient_background.dart'; // Ensure this path is correct
import 'home_page.dart'; // Ensure this is the correct path to your HomePage

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    while (user != null && !isVerified) {
      await user.reload(); // Refresh the user
      user = FirebaseAuth.instance.currentUser;
      setState(() {
        isVerified = user!.emailVerified; // Check if the email is verified
      });
      await Future.delayed(Duration(seconds: 3)); // Check every 3 seconds
    }

    // Navigate to home page after verification
    if (isVerified) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        // Use the gradient background widget
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A verification link has been sent to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white), // Match text style to SignupScreen
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(), // Show loading animation
              SizedBox(height: 20),
              Text(
                "Please verify your email.",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white), // Match text style to SignupScreen
              ),
            ],
          ),
        ),
      ),
    );
  }
}
