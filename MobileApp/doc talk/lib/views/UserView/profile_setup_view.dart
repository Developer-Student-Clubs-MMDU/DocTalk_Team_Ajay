import 'package:doc_talk/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSetupView extends GetView {
  UserController controller = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FarmCare User Form'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          children: [
            // Name Field
            const ListTile(
              title: CircleAvatar(
                radius: 50,
              ),
            ),
            ListTile(
              title: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
            ),

            // DOB Field
            ListTile(
              title: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: controller.dobController,
                  decoration: InputDecoration(
                      labelText: 'Enter your DOB',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  readOnly: true,
                  onTap: () => controller.pickDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    return null;
                  },
                ),
              ),
            ),

            // Email Field
            ListTile(
              title: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                      labelText: 'Enter your email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
            ),

            // Farm Area Field
            ListTile(
              title: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: controller.farmAreaController,
                  decoration: InputDecoration(
                      labelText: 'Enter farm area',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffix: Obx(() {
                        return DropdownButton<String>(
                          value: controller.isAcre.value ? 'Acre' : 'Hectare',
                          items: const [
                            DropdownMenuItem(
                              value: 'Acre',
                              child: Text('Acre'),
                            ),
                            DropdownMenuItem(
                              value: 'Hectare',
                              child: Text('Hectare'),
                            ),
                          ],
                          onChanged: (value) {
                            controller.isAcre.value = value == 'Acre';
                          },
                        );
                      })),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter farm area';
                    }
                    return null;
                  },
                ),
              ),
            ),

            // Location Field (with manual and search options)
            ListTile(
              title: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: controller.locationController,
                  decoration: InputDecoration(
                    labelText: 'Enter your location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => controller.showSearchLocation(),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
              ),
            ),

            // Crop Selection Field
            ListTile(
              title: SizedBox(
                height: 50,
                child: Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.selectedCrop.value.isNotEmpty
                        ? controller.selectedCrop.value
                        : null,
                    decoration: InputDecoration(
                        labelText: 'Select crop',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    items: ['Wheat', 'Rice', 'Corn', 'Cotton']
                        .map((crop) => DropdownMenuItem<String>(
                              value: crop,
                              child: Text(crop),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedCrop.value = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a crop';
                      }
                      return null;
                    },
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: controller.submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
