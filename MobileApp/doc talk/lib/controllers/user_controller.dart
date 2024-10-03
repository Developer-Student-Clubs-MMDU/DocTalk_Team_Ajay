import 'package:doc_talk/views/home/home_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserController extends GetxController {
  //TODO: Implement UserController

  // Controllers for the form fields
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final farmAreaController = TextEditingController();

  var isAcre = true.obs; // Toggle between Acre and Hectare
  var selectedCrop = RxString(''); // Selected crop

  final formKey = GlobalKey<FormState>();


  // Method to pick date
  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  // Dummy location search function
  void showSearchLocation() {
    // Simulate location search
    locationController.text = "Sample Location";
  }

  // Method to handle form submission
  void submitForm() {
    if (formKey.currentState!.validate()) {
      // Process the data (e.g., send it to the backend)
      Get.off(HomePage());
      Get.snackbar('Success', 'Form Submitted Successfully!');
    }
  }



  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose of controllers when done
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    locationController.dispose();
    farmAreaController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
