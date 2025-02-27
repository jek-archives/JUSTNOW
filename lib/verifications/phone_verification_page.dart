import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;

  PhoneVerificationPage({required this.phoneNumber});

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  String smsCode = '';
  bool codeSent = false;

  void verifyPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Phone verified automatically
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Phone verified!")));
        Navigator.pop(context); // Navigate back to ProfilePage
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')));
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  void verifySmsCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Phone verified!")));
      Navigator.pop(context); // Navigate back to ProfilePage
    } catch (e) {
      print('Error verifying SMS code: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid SMS code.')));
    }
  }

  @override
  void initState() {
    super.initState();
    verifyPhone(); // Start phone verification
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Verify your phone number",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            if (codeSent) ...[
              TextField(
                onChanged: (value) {
                  smsCode = value;
                },
                decoration: InputDecoration(
                  labelText: 'Enter SMS Code',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifySmsCode,
                child: Text("Verify"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
