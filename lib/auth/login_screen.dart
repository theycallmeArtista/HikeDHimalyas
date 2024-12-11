import 'dart:async';
import 'dart:developer';
import 'package:HikedHimalayas/activity/bottom_nav.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:HikedHimalayas/auth/auth_service.dart';
import 'package:HikedHimalayas/auth/signup_screen.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false; // Toggle for password visibility

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            bottom: 350,
            child: Image.asset(
              'assets/background2.png', // Your background image
              fit: BoxFit.cover,
            ),
          ),
          // Main content: CardView with form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The Login text and subtext at the top
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // CardView for the Login form
                    Card(
                      elevation: 10,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Input fields for Email and Password
                            FadeInUp(
                              duration: const Duration(milliseconds: 1300),
                              child: makeInput(label: "Email", controller: _emailController),
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1400),
                              child: makeInput(
                                label: "Password",
                                obscureText: !isPasswordVisible, // Toggle visibility here
                                controller: _passwordController,
                                isPassword: true, // New parameter to show/hide icon for password field
                              ),
                            ),
                            // Login button with animation
                            FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: Container(
                                padding: const EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: const Border(
                                    bottom: BorderSide(color: Colors.black),
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60,
                                  onPressed: isLoading ? null : _login,
                                  color: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Display "Login" text when not loading
                                      if (!isLoading)
                                        const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      // Display Lottie animation when loading
                                      if (isLoading)
                                        Lottie.asset(
                                          'assets/loc_anim.json',
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Sign Up Link
                            FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text("Don't have an account?"),
                                  GestureDetector(
                                    onTap: () => goToSignup(context),
                                    child: const Text(
                                      "Sign up",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Input widget for Email and Password with optional toggle for password visibility
  Widget makeInput({required String label, bool obscureText = false, required TextEditingController controller, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            )
                : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Handle login process
  _login() async {
    // Check if email or password fields are empty
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return; // Stop the login process if fields are empty
    }

    setState(() {
      isLoading = true; // Start loading animation
    });

    final user = await _auth.loginUserWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    // Delay added to allow animation to play a little before navigation
    await Future.delayed(const Duration(seconds: 6));

    if (user != null) {
      log("User Logged In");
      goToHome(context);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }

    setState(() {
      isLoading = false; // Stop loading animation after login response
    });
  }

  // Navigate to Signup screen
  goToSignup(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignupScreen()),
  );

  // Navigate to Home screen after login
  goToHome(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const BottomNav()),
  );
}
