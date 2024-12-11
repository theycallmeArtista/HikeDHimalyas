import 'package:HikedHimalayas/pages/Liked.dart';
import 'package:HikedHimalayas/pages/Profile.dart';
import 'package:HikedHimalayas/pages/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home HomePage;
  late Liked liked;
  late ProfileScreen profile;
  int currentTabIndex = 0;

  @override
  void initState() {
    HomePage = Home();
    liked = Liked();
    profile = ProfileScreen();
    pages = [HomePage, liked, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60, // Increased height to allow space for margin
        backgroundColor: const Color(0xff000000),
        color: Colors.white,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0), // Adds a top margin
            child: Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // Adds a top margin
            child: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // Adds a top margin
            child: Icon(
              Icons.person_4_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
