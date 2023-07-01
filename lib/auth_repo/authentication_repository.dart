import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_project/main.dart';
import 'package:my_project/patient_home.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late final Rx<User?> firebaseUser;

  final email = TextEditingController();
  final password = TextEditingController();
  
  @override
  void onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => HomeScreen())
        : Get.offAll(() => PatientHomeScreen());
  }

  Future<void> loginPUser(String email, String password) async {
    try {
      // Retrieve user credentials from Firestore based on the provided email
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Authenticate the user using Firebase Auth
        final UserCredential userCredential = await auth
            .signInWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          // Authentication successful, do something
          Get.snackbar(
            "Success",
            "Logged in successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          );
        } else {
          // Invalid password
          Get.snackbar(
            "Error",
            "Invalid password. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      } else {
        // User not found
        Get.snackbar(
          "Error",
          "User not found. Please check your email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (error, stackTrace) {
      // Handle any errors that occur during the process
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
      print(stackTrace.toString());
    }
  }
}



// class AuthenticationRepository extends GetxController {
//   static AuthenticationRepository get instance => Get.find();

//   final _auth = FirebaseAuth.instance;
//   late final Rx<User?> firebaseUser;

//   @override
//   void onReady() {
//     firebaseUser = Rx<User?>(_auth.currentUser);
//     firebaseUser.bindStream(_auth.userChanges());
//     ever(firebaseUser, _setInitialScreen);
//   }

//   _setInitialScreen(User? user) {
//     user == null
//         ? Get.offAll(() => HomeScreen())
//         : Get.offAll(() => PatientHomeScreen());
//   }
//   Future<void> loginPUser(String email, String password) async {
//     try{
//       await _auth.
//   }
// }
