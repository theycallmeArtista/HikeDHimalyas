import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to add user data to Firestore
  Future<void> addUserData(String uid, Map<String, dynamic> userInfoMap) async {
    try {
      await _firestore.collection("users").doc(uid).set(userInfoMap);
      print("User data added successfully");
    } catch (e) {
      print("Error adding user data: $e");
    }
  }

  // Method to add product data to Firestore
  Future<void> addProductData(String productId, Map<String, dynamic> productInfoMap) async {
    try {
      await _firestore.collection("products").doc(productId).set(productInfoMap);
      print("Product data added successfully");
    } catch (e) {
      print("Error adding product data: $e");
    }
  }

  // Method to add place data to Firestore
  Future<void> addPlaceData(String placeId, Map<String, dynamic> placeInfoMap) async {
    try {
      await _firestore.collection("places").doc(placeId).set(placeInfoMap);
      print("Place data added successfully");
    } catch (e) {
      print("Error adding place data: $e");
    }
  }

  // Method to upload image to Firebase Storage and return the URL
  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child("place_images").child(fileName); // Change folder to 'place_images'
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
