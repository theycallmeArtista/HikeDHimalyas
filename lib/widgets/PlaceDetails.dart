import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class PlaceDetails extends StatefulWidget {
  final String placeId;
  final Map<String, dynamic> placeData;

  const PlaceDetails({Key? key, required this.placeId, required this.placeData})
      : super(key: key);

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> placeData;
  int _currentIndex = 0;
  late AnimationController _animationController;
  bool _isExpanded = false;
  bool _showLottie = false;
  late Timer _lottieTimer;

  @override
  void initState() {
    super.initState();
    placeData = widget.placeData;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_lottieTimer.isActive) {
      _lottieTimer.cancel();
    }
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _showLottieFor6Seconds() {
    setState(() {
      _showLottie = true;
    });

    _lottieTimer = Timer(Duration(seconds: 6), () {
      setState(() {
        _showLottie = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> galleryUrls = List<String>.from(placeData['galleryUrls'] ?? []);
    String difficulty = placeData['difficulty'] ?? "Moderate";
    String distance = placeData['distance'] ?? "N/A";
    String elevation = placeData['elevation'] ?? "N/A";
    String duration = placeData['duration'] ?? "N/A";
    String rating = placeData['rating'] ?? "N/A";

    List<String> sections = [
      placeData['overview'] ?? "Overview not available.",
      placeData['whoCanGo'] ?? "Audience information not available.",
      placeData['itinerary'] ?? "Itinerary details not available.",
      placeData['graph'] ?? "Graph details not available.",
      placeData['howToReach'] ?? "How to reach information not available.",
      placeData['costTerms'] ?? "Cost terms not available.",
      placeData['trekEssentials'] ?? "Trek essentials not available.",
    ];

    List<String> sectionTitles = [
      "Overview",
      "Who Can Go",
      "Itinerary",
      "Elevation Graph",
      "How to Reach",
      "Cost Terms",
      "Trek Essentials",
    ];

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          // Image gallery with fade-in animation
          PageView.builder(
            itemCount: galleryUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _animationController.reset();
                _animationController.forward();
                _isExpanded = false;

                if (index == 1) {
                  _showLottieFor6Seconds();
                }
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  FadeIn(
                    child: Image.network(
                      galleryUrls.isNotEmpty ? galleryUrls[index] : 'https://via.placeholder.com/300',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(color: Colors.black.withOpacity(0.3)),

                  // First Slide: Show place details
                  if (index == 0)
                    Positioned(
                      bottom: 40,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Place Name
                          FadeInDown(
                            child: Text(
                              placeData['name'] ?? 'Unknown Place',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontFamily: 'Play',
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Place Location
                          FadeInDown(
                            delay: const Duration(milliseconds: 300),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Ionicons.location_outline, color: Colors.white70, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  placeData['location'] ?? 'Unknown Location',
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 280),
                          // Distance, Elevation, Duration, Rating
                          FadeInUp(
                            delay: const Duration(milliseconds: 500),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildInfoColumn("Distance", distance),
                                _buildVerticalLine(),
                                _buildInfoColumn("Elevation", elevation),
                                _buildVerticalLine(),
                                _buildInfoColumn("Duration", duration),
                                _buildVerticalLine(),
                                _buildInfoColumn("Rating", "⭐ $rating"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Subsequent Slides: Expandable Card with information
                  if (index > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! < 0) {
                            _toggleExpand();
                          } else {
                            setState(() => _isExpanded = false);
                          }
                        },
                        child: ClipPath(
                          clipper: CurvedCardClipper(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: _isExpanded ? MediaQuery.of(context).size.height * 0.7 : 80,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  sectionTitles[(index - 1) % sectionTitles.length],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (!_isExpanded)
                                  Text(
                                    sections[(index - 1) % sections.length],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                                  ),
                                if (_isExpanded)
                                  FadeIn(
                                    child: Text(
                                      sections[(index - 1) % sections.length],
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Lottie Animation on Second Slide
                  if (index == 1 && _showLottie)
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Lottie.asset(
                          'assets/swipe-anim.json',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Slide Indicators
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(galleryUrls.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.white : Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // Back button and difficulty badge
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Ionicons.chevron_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                difficulty,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildVerticalLine() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white70,
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}

class CurvedCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
