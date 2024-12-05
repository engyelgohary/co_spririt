import 'package:co_spirit/core/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../forms/import_data_form.dart';

class OmSettings extends StatefulWidget {
  const OmSettings({Key? key}) : super(key: key);

  @override
  State<OmSettings> createState() => _OmSettingsState();
}

class _OmSettingsState extends State<OmSettings> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }
  void _openForm() {
    // Open form when "Import data" is clicked
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const ImportForm(); // Call the separated form here
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Profile Management :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 40),

                // Profile Image with Upload Button
                Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: _profileImage == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppUI.omMainColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Olivier Matteo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppUI.omMainColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Full Name Field
                const Text(
                  "Full Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: "Olivier Matteo",
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true, // Required to enable fillColor
                    fillColor: Color(0xFFDFE8F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),

                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email Address Field
                const Text(
                  "Email Address",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: "Oliviermatteo@gmail.com",
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true, // Required to enable fillColor
                    fillColor: Color(0xFFDFE8F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),

                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Role Field
                const Text(
                  "Role",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: "Opportunity Manager",
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true, // Required to enable fillColor
                    fillColor: Color(0xFFDFE8F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),

                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                GestureDetector(
                  onTap: () {
                    // TODO: Handle password update navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Update Password clicked!'),
                      ),
                    );
                  },
                  child: const Text(
                    "Update Password",
                    style: TextStyle(
                      color: AppUI.omSecondColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _openForm,
                  child: const Text(
                    "Import data",
                    style: TextStyle(
                      color: AppUI.omSecondColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}