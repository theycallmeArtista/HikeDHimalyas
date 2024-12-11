import 'package:HikedHimalayas/Admin/admin_login.dart';
import 'package:HikedHimalayas/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:HikedHimalayas/widgets/app_largetext.dart';

import '../widgets/PlaceDetails.dart';
import '../widgets/app_text.dart';
import 'drawer_screen.dart';
import 'package:animate_do/animate_do.dart'; // Import animate_do

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  // Track liked places
  Set<String> likedPlaces = {};

  @override
  void initState() {
    super.initState();
    loadLikedPlaces(); // Load liked places when the screen is initialized
  }

  // Load liked places from Firestore on initialization
  void loadLikedPlaces() async {
    var snapshot = await _firestore.collection('likedPlaces').get();
    setState(() {
      likedPlaces = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  // Fetch data from Firestore
  Stream<QuerySnapshot> getPlaces() {
    return _firestore.collection('places').orderBy('timestamp', descending: true).snapshots();
  }

  // Toggle the like status of a place
  void toggleLike(String placeId) {
    setState(() {
      if (likedPlaces.contains(placeId)) {
        likedPlaces.remove(placeId);
        _firestore.collection('likedPlaces').doc(placeId).delete();
      } else {
        likedPlaces.add(placeId);
        _firestore.collection('likedPlaces').doc(placeId).set({'placeId': placeId});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SlideInLeft( // Animate the drawer sliding in from the left
            duration: const Duration(milliseconds: 100),
            child: DrawerScreen(),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(isDrawerOpen ? -0.05 : 0),
            duration: const Duration(milliseconds: 80),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 140), // 20 pixels from the top
                  child: StreamBuilder<QuerySnapshot>(
                    stream: getPlaces(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(child: Text('Error loading places.'));
                      }

                      var places = snapshot.data?.docs ?? [];

                      if (places.isEmpty) {
                        return const Center(child: Text('No places found.'));
                      }

                      return PageView.builder(
                        controller: _pageController,
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          var place = places[index].data() as Map<String, dynamic>;
                          var placeId = places[index].id;

                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              double value = 1;
                              if (_pageController.position.haveDimensions) {
                                value = _pageController.page! - index;
                                value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                              }

                              return Align(
                                alignment: const Alignment(0, 0.4),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaceDetails(
                                          placeId: placeId,
                                          placeData: place,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Transform.scale(
                                    scale: value,
                                    child: Opacity(
                                      opacity: value,
                                      child: ZoomIn(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                          width: MediaQuery.of(context).size.width * 0.75,
                                          height: 380,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.black, width: 1),
                                            image: DecorationImage(
                                              image: NetworkImage(place['imageUrl']),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.9),
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [

                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.4),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                              ),
                                              // Heart icon at the top-left corner
                                              Positioned(
                                                top: 10,
                                                left: 10,
                                                child: GestureDetector(
                                                  onTap: () => toggleLike(placeId),
                                                  child: Icon(
                                                    likedPlaces.contains(placeId)
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: likedPlaces.contains(placeId)
                                                        ? Colors.red
                                                        : Colors.white,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    AppLargetext(
                                                      text: place['name'],
                                                      size: 28,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      width: 200,
                                                      height: 2,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    AppText(
                                                      text: "${place['location'] ?? 'Unknown'}",
                                                      size: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isDrawerOpen
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                isDrawerOpen = false;
                              });
                            },
                            child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                          )
                              : GestureDetector(
                            onTap: () {
                              setState(() {
                                xOffset = 250;
                                yOffset = 100;
                                isDrawerOpen = true;
                              });
                            },
                            child: const Icon(Icons.menu, color: Colors.black),
                          ),
                          IconButton(
                            icon: const Icon(Icons.person, color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ZoomIn(
                              child: const Text(
                                'HikeDHimalayas',
                                style: TextStyle(
                                  fontFamily: 'Play',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            ZoomIn(
                              child: Container(
                                width: 200,
                                height: 2,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            ZoomIn(
                              child: const Text(
                                '"Your Gateway to the Majestic Himalayas"',
                                style: TextStyle(
                                  fontFamily: 'Rock',
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ** Add two new cards with the "Know More" button below the main card **
                Positioned(
                  bottom: 40, // Add space between main cards and the new ones
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      // First new card
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blueAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Card Image or Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage('https://via.placeholder.com/80'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLargetext(text: 'Place Name', size: 16, color: Colors.white),
                                  const SizedBox(height: 5),
                                  AppText(text: 'Location', size: 12, color: Colors.white),
                                ],
                              ),
                            ),
                            // "Know More" button
                            GestureDetector(
                              onTap: () {
                                // Navigate to detailed page for this new card
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Know More',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Second new card
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.greenAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Card Image or Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage('https://via.placeholder.com/80'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLargetext(text: 'Another Place', size: 16, color: Colors.white),
                                  const SizedBox(height: 5),
                                  AppText(text: 'Another Location', size: 12, color: Colors.white),
                                ],
                              ),
                            ),
                            // "Know More" button
                            GestureDetector(
                              onTap: () {
                                // Navigate to detailed page for this new card
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Know More',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
