import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _userName = 'Loading...';
  String _profilePicUrl = '';

  int _selectedIndex = 0; // To keep track of the selected item

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
        _userName = docSnapshot['name'];
        _profilePicUrl = docSnapshot['profile_picture'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF424242), // Charcoal background color
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Profile Section with dynamic data from Firestore
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _profilePicUrl.isNotEmpty
                      ? NetworkImage(_profilePicUrl)
                      : const AssetImage('assets/profile_pic.png') as ImageProvider,
                ),
                SizedBox(width: 10),
                Text(
                  _userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Drawer menu items
            Column(
              children: <Widget>[
                _buildDrawerItem(
                  icon: Icons.home,
                  text: 'Home',
                  index: 0, // To identify which item is selected
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerItem(
                  icon: Icons.favorite,
                  text: 'Favorites',
                  index: 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    Navigator.pushNamed(context, '/favorites');
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerItem(
                  icon: Icons.person_4_outlined,
                  text: 'Profile',
                  index: 2,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  index: 3,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                const SizedBox(height: 20),
                _buildDrawerItem(
                  icon: Icons.more_outlined,
                  text: 'Other Activities',
                  index: 4,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                    Navigator.pushNamed(context, '/activities');
                  },
                ),
              ],
            ),
            // Log out section
            Row(
              children: <Widget>[
                Icon(
                  Icons.cancel,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'Log out',
                    style: TextStyle(color: Colors.white.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Drawer item with onTap functionality and selected item highlight
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap, required int index}) {
    bool isSelected = _selectedIndex == index; // Check if this item is selected
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: isSelected ? Color(0xFF4FC3F7) : Colors.white, // Light Blue for selected item
          ),
          const SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Color(0xFF4FC3F7) : Colors.white, // Light Blue for selected item
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
