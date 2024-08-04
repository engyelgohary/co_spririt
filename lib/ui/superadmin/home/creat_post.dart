import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';

class CreatePost extends StatefulWidget {
  final ApiManager apiManager;

  const CreatePost({required this.apiManager, Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _inputController = TextEditingController();
  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('adminId');

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('User ID not found.')));
      return;
    }

    String title = _inputController.text;
    String content = _inputController.text;
    File? imageFile = _pickedFile != null ? File(_pickedFile!.path) : null;

    try {
      bool success = await widget.apiManager.createPost(
        title,
        content,
        image: imageFile,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post created successfully!')));
        Navigator.of(context).pop(); // Close the modal after creating the post
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create post.')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double iconSize = screenWidth * 0.08;
    final double horizontalPadding = screenWidth * 0.03;
    final double verticalPadding = screenHeight * 0.02;
    final double buttonSize = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: AppUI.whiteColor,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: iconSize,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: horizontalPadding),
                CustomText(
                  text: 'Create post',
                  fontSize: screenWidth * 0.04,
                  color: AppUI.blackColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(height: verticalPadding),
            Divider(
              thickness: screenWidth * 0.007,
            ),
            SizedBox(height: verticalPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: _inputController.text.isEmpty
                      ? 'Whats on your mind?'
                      : _inputController.text,
                  fontSize: screenWidth * 0.05,
                  color: AppUI.blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const Spacer(),
            SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: CustomInput(
                      borderColor: const Color.fromRGBO(241, 241, 241, 1),
                      fillColor: const Color.fromRGBO(241, 241, 241, 1),
                      controller: _inputController,
                      hint: "Post Content",
                      textInputType: TextInputType.text,
                      suffixIcon: InkWell(
                        onTap: () async {
                          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _pickedFile = pickedFile;
                            });
                          }
                        },
                        child: ImageIcon(
                        const AssetImage('${AppUI.iconPath}file.png'),
                        color: AppUI.twoBasicColor,
                        size: screenWidth * 0.06,
                      ),),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  InkWell(
                    onTap: _createPost,
                    child: Container(
                      height: buttonSize,
                      width: buttonSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(buttonSize / 2),
                        color: AppUI.secondColor,
                      ),
                      child: Center(
                        child: ImageIcon(
                          const AssetImage('${AppUI.iconPath}send.png'),
                          color: AppUI.whiteColor,
                          size: buttonSize * 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
