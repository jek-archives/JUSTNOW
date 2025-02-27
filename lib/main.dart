import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_option.dart'; // Import the new file
import 'screens/welcome_screen.dart';
import 'providers/cart_provider.dart'; // Import CartProvider
import 'package:provider/provider.dart'; // Import Provider package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the Firebase config
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(), // Provide CartProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      ),
    );
  }
}
