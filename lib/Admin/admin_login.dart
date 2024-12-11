import 'dart:developer';
import 'package:HikedHimalayas/Admin/addproduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to handle admin login using Firestore
  Future<void> _loginAdmin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show error if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    try {
      // Query the Firestore collection 'admin' to find a matching email
      QuerySnapshot snapshot = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the admin document
        var adminData = snapshot.docs.first.data() as Map<String, dynamic>;

        // Compare the entered password with the stored password
        if (adminData['password'] == password) {
          // If the password matches, log success and navigate to the admin dashboard or home screen
          log('Admin login successful');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful!')),
          );

          // Navigate to admin home or dashboard
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlacePage()),
          );
        } else {
          // Show error if password is incorrect
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password.')),
          );
        }
      } else {
        // Show error if no matching admin found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin not found.')),
        );
      }
    } catch (e) {
      // Handle any errors during the Firestore query
      log('Error during admin login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'img/camp.png', // Path to your image
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Admin Login",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _loginAdmin, // Call the admin login method
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), // Full width button
              ),
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Forgot your password? "),
              InkWell(
                onTap: () {
                  // Handle reset password or help here
                },
                child: const Text(
                  "Reset here",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.hintStyle,
    this.labelStyle,
  });

  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey[600]),
        labelText: label,
        labelStyle: labelStyle ?? const TextStyle(color: Colors.blueAccent),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}

// Placeholder Admin Home Screen (after login)
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to the Admin Dashboard!'),
      ),
    );
  }
}
