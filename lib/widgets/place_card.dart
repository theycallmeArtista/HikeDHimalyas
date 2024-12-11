import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String placeId;
  final Map<String, dynamic> placeData;
  final Set<String> likedPlaces;
  final Function(String) toggleLike;
  final String placeholderImage; // Add placeholder image

  const PlaceCard({
    Key? key,
    required this.placeId,
    required this.placeData,
    required this.likedPlaces,
    required this.toggleLike,
    required this.placeholderImage, // Make placeholder image required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeInImage.assetNetwork(
              placeholder: placeholderImage, // Use the provided placeholder image
              image: placeData['imageUrl'] ?? '',
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  placeholderImage,
                  fit: BoxFit.cover,
                );
              },
            ),
            // Overlay with title and like button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      placeData['name'] ?? 'Unknown Place',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          placeData['location'] ?? 'Unknown Location',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        IconButton(
                          icon: Icon(
                            likedPlaces.contains(placeId)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: likedPlaces.contains(placeId) ? Colors.red : Colors.white,
                          ),
                          onPressed: () => toggleLike(placeId),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
