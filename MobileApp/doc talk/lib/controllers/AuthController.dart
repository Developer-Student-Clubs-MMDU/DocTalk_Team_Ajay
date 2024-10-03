import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/userModel.dart'; // Import the DeviceModel class

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final String userId = user.uid;

      final UserData userData = UserData(
          name: name, email: email, userId: userId, profileImageUrl: '');

      // Reference to the user node in Realtime Database
      final userRef = FirebaseFirestore.instance.collection('users').doc(
          userId);

      // Save user data to Realtime Database
      await userRef.set(userData.toMap());

      // Sign up successful
      Get.snackbar('Success', 'Sign up successful');
    } catch (error) {
      // Handle sign up errors
      Get.snackbar('Error', error.toString());
      print(error.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Sign In successful : ${_auth.currentUser!.uid}');
    } catch (error) {
      // Handle sign up errors
      Get.snackbar('Error', error.toString());
    }
  }
}
