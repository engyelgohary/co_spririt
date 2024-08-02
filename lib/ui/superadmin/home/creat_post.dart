import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/Post.dart'; // Import the Post model

class CreatePost extends StatefulWidget {
  final ApiManager apiManager;

  CreatePost({required this.apiManager, Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _createPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('adminId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User ID not found.')));
      return;
    }

    String title = _titleController.text;
    String content = _contentController.text;

    try {
      bool success = await widget.apiManager.createPost(title, content);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post created successfully!')));
        Navigator.of(context).pop(); // Close the modal after creating the post
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create post.')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
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

    return Padding(
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
                  Navigator.of(context).pop(); // Closes the modal bottom sheet
                },
              ),
              SizedBox(width: horizontalPadding),
              CustomText(
                text: 'Create post',
                fontSize: screenWidth * 0.04, // Adjust font size based on screen width
                color: AppUI.blackColor,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          SizedBox(height: verticalPadding),
          Divider(
            thickness: screenWidth * 0.007, // Adjust thickness based on screen width
          ),
          SizedBox(height: verticalPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Lorem ipsum dolor sit',
                fontSize: screenWidth * 0.05,
                color: AppUI.blackColor,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: 'amet, consectetur?',
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
                    controller: _titleController,
                    hint: "Post Title",
                    textInputType: TextInputType.text,
                    suffixIcon: SizedBox(
                      width: screenWidth * 0.3, // Adjust width based on screen width
                      child: Row(
                        children: [
                          ImageIcon(
                            const AssetImage('${AppUI.iconPath}file.png'),
                            color: AppUI.twoBasicColor,
                            size: screenWidth * 0.06, // Adjust icon size based on screen width
                          ),
                          SizedBox(width: screenWidth * 0.02), // Adjust spacing based on screen width
                          ImageIcon(
                            const AssetImage('${AppUI.iconPath}chatcamera.png'),
                            color: AppUI.twoBasicColor,
                            size: screenWidth * 0.06, // Adjust icon size based on screen width
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02), // Adjust spacing based on screen width
                Expanded(
                  child: CustomInput(
                    borderColor: const Color.fromRGBO(241, 241, 241, 1),
                    fillColor: const Color.fromRGBO(241, 241, 241, 1),
                    controller: _contentController,
                    hint: "Post Content",
                    textInputType: TextInputType.text,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02), // Adjust spacing based on screen width
                InkWell(
                  onTap: _createPost, // Call the create post function
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
                        size: buttonSize * 0.6, // Adjust icon size based on button size
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
