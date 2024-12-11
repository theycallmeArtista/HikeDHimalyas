import 'dart:developer';
import 'dart:io';
import 'package:HikedHimalayas/auth/auth_service.dart';
import 'package:HikedHimalayas/auth/login_screen.dart';

import 'package:HikedHimalayas/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';  // For the loading animation

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _profileImage;
  String? _imageUrl;
  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 320,
            child: Image.asset(
              'assets/background2.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                // Profile Picture
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage == null
                          ? const AssetImage('assets/profile_pic.png')
                          : FileImage(_profileImage!) as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: const Text(
                    "Add Profile Photo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                // Sign-up Form Container
                Card(
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  margin: const EdgeInsets.only(top: 30, left: 15, right: 15),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: makeInput(label: "Name", controller: _nameController),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: makeInput(label: "Email", controller: _emailController),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: makeInput(
                            label: "Password",
                            controller: _passwordController,
                            obscureText: !isPasswordVisible,
                            isPassword: true,
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.black),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: isLoading ? null : _signup,
                              color: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (!isLoading)
                                    const Text(
                                      "Sign up",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
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
                        // Already have an account? Login Link
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Already have an account?"),
                              GestureDetector(
                                onTap: () => goToLogin(context),
                                child: const Text(
                                  " Login",
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
        ],
      ),
    );
  }

  Widget makeInput({required String label, required TextEditingController controller, bool obscureText = false, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
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
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  _uploadProfileImage() async {
    if (_profileImage == null) return;

    final storageRef = FirebaseStorage.instance.ref().child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(_profileImage!);
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      _imageUrl = imageUrl;
    });
  }

  _signup() async {
    if (_passwordController.text.isEmpty || _emailController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (_profileImage != null) {
      await _uploadProfileImage();
    }

    final user = await _auth.createUserWithEmailAndPassword(_emailController.text, _passwordController.text);
    if (user != null) {
      log("User Created Successfully");

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'profile_picture': _imageUrl ?? '',
      });

      goToHome(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign Up Failed")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );

  goToHome(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Home()),
  );
}
