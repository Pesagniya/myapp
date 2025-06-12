import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/profile/profile_model.dart'; // Import your model

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Fetches complete user profile including auth email
  Future<Profile?> fetchUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      return Profile.fromFirebase(
        doc.data()!,
        uid: user.uid,
        email: user.email,
      );
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Uploads profile photo and updates Firestore
  Future<String?> uploadProfilePhoto() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      // Define storage path
      final storageRef = _storage
          .ref()
          .child('profile_photos')
          .child('${user.uid}.jpg');

      // Upload with progress tracking capability
      await storageRef.putFile(File(image.path));

      // Get permanent download URL
      final photoUrl = await storageRef.getDownloadURL();

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'photoUrl': photoUrl,
      }, SetOptions(merge: true));

      return photoUrl;
    } catch (e) {
      throw Exception('Photo upload failed: $e');
    }
  }

  /// Saves complete profile data
  Future<void> saveProfile(Profile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toFirebase(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }
}
