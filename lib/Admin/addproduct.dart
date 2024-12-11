import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:HikedHimalayas/services/database.dart'; // Import DatabaseMethods
import '../pages/home_screen.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _placeNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _overviewController = TextEditingController();
  final _whoCanGoController = TextEditingController();
  final _itineraryController = TextEditingController();
  final _graphController = TextEditingController();
  final _howToReachController = TextEditingController();
  final _costTermsController = TextEditingController();
  final _trekEssentialsController = TextEditingController();
  final _distanceController = TextEditingController();
  final _elevationController = TextEditingController();
  final _durationController = TextEditingController();
  final _ratingController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  List<XFile>? _galleryImages = [];

  final DatabaseMethods _databaseMethods = DatabaseMethods();
  final List<String> _categories = ['Easy', 'Medium', 'Hard'];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Add Place',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? Image.file(
                File(_selectedImage!.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField(_placeNameController, "Place Name", "Enter Place Name"),
            const SizedBox(height: 20),
            _buildTextField(_locationController, "Location", "Enter Location"),
            const SizedBox(height: 20),
            _buildTextField(_overviewController, "Overview", "Enter Overview", maxLines: 4),
            const SizedBox(height: 20),
            _buildTextField(_whoCanGoController, "Who can go?", "Enter target audience", maxLines: 2),
            const SizedBox(height: 20),
            _buildTextField(_itineraryController, "Itinerary", "Enter Itinerary", maxLines: 4),
            const SizedBox(height: 20),
            _buildTextField(_graphController, "Graph", "Enter Graph description", maxLines: 2),
            const SizedBox(height: 20),
            _buildTextField(_howToReachController, "How to Reach", "Enter details about reaching", maxLines: 3),
            const SizedBox(height: 20),
            _buildTextField(_costTermsController, "Cost Terms", "Enter Cost Terms", maxLines: 3),
            const SizedBox(height: 20),
            _buildTextField(_trekEssentialsController, "Trek Essentials", "Enter Trek Essentials", maxLines: 3),
            const SizedBox(height: 20),

            // Additional fields
            _buildTextField(_distanceController, "Distance", "Enter Distance (e.g., 10 km)"),
            const SizedBox(height: 20),
            _buildTextField(_elevationController, "Elevation", "Enter Elevation (e.g., 319 m)"),
            const SizedBox(height: 20),
            _buildTextField(_durationController, "Duration", "Enter Duration (e.g., 2h 50m)"),
            const SizedBox(height: 20),
            _buildTextField(_ratingController, "Rating", "Enter Rating (e.g., 4.7)"),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text('Select Difficulty'),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Difficulty Level',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Gallery images picker
            GestureDetector(
              onTap: _pickGalleryImages,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                ),
                child: const Icon(Icons.photo_library, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // Display selected gallery images
            _galleryImages != null && _galleryImages!.isNotEmpty
                ? Wrap(
              spacing: 10,
              children: _galleryImages!.map((image) {
                return Image.file(
                  File(image.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                );
              }).toList(),
            )
                : const SizedBox(),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addPlace,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Add Place'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.green,
              ),
              child: const Text('Go to Home'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickGalleryImages() async {
    final List<XFile>? images = await _imagePicker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      setState(() {
        _galleryImages = images;
      });
    }
  }

  Future<void> _addPlace() async {
    String placeName = _placeNameController.text.trim();
    String location = _locationController.text.trim();
    String overview = _overviewController.text.trim();
    String whoCanGo = _whoCanGoController.text.trim();
    String itinerary = _itineraryController.text.trim();
    String graph = _graphController.text.trim();
    String howToReach = _howToReachController.text.trim();
    String costTerms = _costTermsController.text.trim();
    String trekEssentials = _trekEssentialsController.text.trim();
    String distance = _distanceController.text.trim();
    String elevation = _elevationController.text.trim();
    String duration = _durationController.text.trim();
    String rating = _ratingController.text.trim();
    String? selectedCategory = _selectedCategory;

    if (placeName.isEmpty || location.isEmpty || selectedCategory == null || _selectedImage == null || distance.isEmpty || elevation.isEmpty || duration.isEmpty || rating.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and select an image.')));
      return;
    }

    String? imageUrl = await _databaseMethods.uploadImageToStorage(File(_selectedImage!.path));
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error uploading image')));
      return;
    }

    List<String> galleryUrls = [];
    for (var galleryImage in _galleryImages!) {
      String? galleryUrl = await _databaseMethods.uploadImageToStorage(File(galleryImage.path));
      if (galleryUrl != null) {
        galleryUrls.add(galleryUrl);
      }
    }

    Map<String, dynamic> placeData = {
      'name': placeName,
      'location': location,
      'overview': overview,
      'whoCanGo': whoCanGo,
      'itinerary': itinerary,
      'graph': graph,
      'howToReach': howToReach,
      'costTerms': costTerms,
      'trekEssentials': trekEssentials,
      'difficulty': selectedCategory,
      'distance': distance,
      'elevation': elevation,
      'duration': duration,
      'rating': rating,
      'imageUrl': imageUrl,
      'galleryUrls': galleryUrls,
      'timestamp': FieldValue.serverTimestamp(),
    };

    String placeId = DateTime.now().millisecondsSinceEpoch.toString();
    await _databaseMethods.addPlaceData(placeId, placeData);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Place added successfully!')));
    _placeNameController.clear();
    _locationController.clear();
    _overviewController.clear();
    _whoCanGoController.clear();
    _itineraryController.clear();
    _graphController.clear();
    _howToReachController.clear();
    _costTermsController.clear();
    _trekEssentialsController.clear();
    _distanceController.clear();
    _elevationController.clear();
    _durationController.clear();
    _ratingController.clear();
    setState(() {
      _selectedImage = null;
      _galleryImages = [];
      _selectedCategory = null;
    });
  }
}
