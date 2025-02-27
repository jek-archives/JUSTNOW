import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/gradient_background.dart';
import '/widgets/bottom_navbar.dart'; // Ensure this imports your custom BottomNavBar
import '/verifications/phone_verification_page.dart'; // Import your Phone Verification page
import 'home_page.dart'; // Import HomePage for navigation

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String profileImageUrl = "https://via.placeholder.com/150";
  String gender = 'Male'; // Default value for gender
  List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        nameController.text =
            user.displayName ?? ''; // Fetch user's name if available
        emailController.text = user.email ?? ''; // Fetch user's email
        phoneController.text =
            user.phoneNumber ?? ''; // Fetch user's phone number if available
      });
    }
  }

  void updateProfile() {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!")),
      );
    });
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return phoneNumber.replaceFirst('0', '+63'); // Change leading 0 to +63
    } else if (phoneNumber.startsWith('63')) {
      return '+' + phoneNumber; // Ensure it has a leading +
    } else {
      return '+63' + phoneNumber; // Add +63 for formatting
    }
  }

  void _navigateToPhoneVerification() {
    String formattedPhone = formatPhoneNumber(phoneController.text);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PhoneVerificationPage(phoneNumber: formattedPhone)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Height matching HomePage
        child: AppBar(
          title: Text("User Profile"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          toolbarHeight:
              80.0, // Ensure toolbar height matches the desired height
        ),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Implement function to pick image
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter your name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Gender"),
              DropdownButton<String>(
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                items:
                    genderOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _navigateToPhoneVerification,
                child: _buildTextField(phoneController, 'Phone', Icons.phone),
              ),
              const SizedBox(height: 20),
              _buildTextField(emailController, 'Email',
                  Icons.email), // Email field is now read-only
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade300,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child:
                    const Text("Save", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Set index to 2 for the "Me" tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()), // Navigate to Home
              );
              break;
            case 1:
              Navigator.pushNamed(
                  context, '/notifications'); // Navigate to Notifications
              break;
            case 2:
              // Already on ProfilePage, do nothing or optionally pop
              break;
          }
        },
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLength:
            label == 'Phone' ? 10 : null, // Limit input to 10 digits for phone
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          counterText: '', // Hide the counter text
        ),
        keyboardType:
            label == "Phone" ? TextInputType.phone : TextInputType.emailAddress,
        readOnly: label == "Email", // Make email field read-only
      ),
    );
  }
}
