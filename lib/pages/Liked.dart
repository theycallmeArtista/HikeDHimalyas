import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/PlaceDetails.dart';
import '../widgets/app_largetext.dart';
import '../widgets/app_text.dart';

class Liked extends StatefulWidget {
  const Liked({super.key});

  @override
  State<Liked> createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch liked places from Firestore
  Stream<QuerySnapshot> getLikedPlaces() {
    return _firestore.collection('likedPlaces').snapshots();
  }

  // Remove place from liked places
  Future<void> removeLikedPlace(String placeId) async {
    await _firestore.collection('likedPlaces').doc(placeId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getLikedPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading liked places.'));
          }

          var likedPlaceDocs = snapshot.data?.docs ?? [];

          if (likedPlaceDocs.isEmpty) {
            return const Center(child: Text('You have no liked places.'));
          }

          return ListView.builder(
            itemCount: likedPlaceDocs.length,
            itemBuilder: (context, index) {
              var likedPlaceId = likedPlaceDocs[index]['placeId'];

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('places').doc(likedPlaceId).get(),
                builder: (context, placeSnapshot) {
                  if (placeSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!placeSnapshot.hasData || placeSnapshot.data?.data() == null) {
                    return const ListTile(
                      title: Text('Place not found'),
                    );
                  }

                  var placeData = placeSnapshot.data!.data() as Map<String, dynamic>;

                  return ZoomIn(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetails(
                              placeId: likedPlaceId,
                              placeData: placeData,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        height: 380,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(placeData['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 8,
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
                            // Heart icon at the top-right corner
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  await removeLikedPlace(likedPlaceId);
                                  setState(() {}); // Refresh list after removal
                                },
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
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
                                    text: placeData['name'] ?? 'Unnamed Place',
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
                                    text: "${placeData['location'] ?? 'Unknown'}",
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
