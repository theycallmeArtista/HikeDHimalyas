import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _name;
  String? _email;
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser; // Get current user
    if (_user != null) {
      _getUserProfile();
    }
  }

  // Fetch user profile data from Firestore
  Future<void> _getUserProfile() async {
    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(_user?.uid).get();

    if (docSnapshot.exists) {
      setState(() {
        _name = docSnapshot['name'];
        _email = docSnapshot['email'];
        _profilePictureUrl = docSnapshot['profile_picture'];
      });
    }
  }

  // Function to handle the settings button touch
  void _onSettingsPressed() {
    // Here you can add the action you want to perform when the settings button is pressed
    print("Settings button pressed");
    // For example, navigate to the settings screen:
    // Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Stack(
              alignment: Alignment.center,
              children: [
                // Background Image
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/profile_bac.jpeg"), // Update with your actual path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Profile Picture and Name (shifted down)
                Positioned(
                  top: 100, // Adjusted to shift the image lower
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _profilePictureUrl != null
                            ? NetworkImage(_profilePictureUrl!) as ImageProvider
                            : const AssetImage('assets/profile_pic.png'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _name ?? 'Loading...',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontFamily: 'Play',
                        ),
                      ),
                      Text(
                        _email ?? 'Loading...',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Settings Icon (added GestureDetector)
                Positioned(
                  top: 40,
                  right: 20,
                  child: GestureDetector(
                    onTap: _onSettingsPressed, // Handle the settings button press
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("1,250", "Activities"),
                  _buildStatItem("239", "Experiences"),
                  _buildStatItem("125", "Followers"),
                ],
              ),
            ),

            Divider(),

            // Activities Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Activities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildActivityItem("Valley of the king & beyond", "Giza", "17/08/2019"),
                  _buildActivityItem("Beaches of Caribbean", "Bahamas", "17/08/2019"),
                  _buildActivityItem("Killing the mountain", "Unknown", "17/08/2019"),
                ],
              ),
            ),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
                },
                child: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for a single stat item
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // Widget for an activity item
  Widget _buildActivityItem(String title, String location, String date) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(location),
        trailing: Text(date),
      ),
    );
  }
}
