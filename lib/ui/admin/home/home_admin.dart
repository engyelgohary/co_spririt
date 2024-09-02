import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/GetAdmin.dart';
import '../../../data/model/Post.dart';
import '../../superadmin/home/creat_post.dart';
import '../Menu/menu_admin.dart';
import '../Message/Message_admin.dart';
import '../Notifactions/notifictionadmin.dart';
import '../Profile/profile_admin.dart';
import '../requests/request_admin.dart';

class HomeScreenAdmin extends StatefulWidget {
   HomeScreenAdmin({Key? key, required this.admin,required this.adminId}) : super(key: key);
  static String routeName = 'home screen admin';
  final GetAdmin admin;
  final String adminId;

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  late GetAdmin admin;
  late ApiManager apiManager;
  late Future<List<Post>> adminPosts;


  @override
  void initState() {
    super.initState();
    admin = widget.admin;
    apiManager = ApiManager.getInstance();
    adminPosts = apiManager.fetchAdminPosts();

  }


  void reloadPosts() {
    setState(() {
      adminPosts = apiManager.fetchAdminPosts();
    });
  }

  Future<Post?> _showEditDialog(BuildContext context, Post post) async {
    final contentController = TextEditingController(text: post.content);

    return showDialog<Post?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: TextField(
            controller: contentController,
            decoration: const InputDecoration(labelText: 'Content'),
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedPost = Post(
                  id: post.id,
                  title: contentController.text,
                  content: contentController.text,
                  // other fields if needed
                );
                Navigator.of(context).pop(updatedPost);
                reloadPosts();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(children: [
          Stack(
            children: [
              Image.asset(
                '${AppUI.imgPath}Rectangle 15.png',
                height: 191.h,
                width: 375.w,
                fit: BoxFit.fill,
              ),
              Column(
                children: [
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          '${AppUI.imgPath}logo.png',
                          height: 28.h,
                          width: 100.w,
                        ),
                        InkWell(
                          onTap: () {
                            AppUtil.mainNavigator(
                                context, const NotificationScreenAdmin());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 13.w),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: AppUI.borderColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: reloadPosts,
                            child: const ImageIcon(
                              AssetImage("${AppUI.iconPath}Home.png"),
                              size: 24,
                              color: AppUI.secondColor,
                              semanticLabel: 'Home',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const CustomText(
                            text: 'Home',
                            fontSize: 12,
                            color: AppUI.secondColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, RequestAdmin());
                        },
                        child: const Column(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "${AppUI.iconPath}request.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              text: 'Requests',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, MessagesScreenAdmin());
                        },
                        child: const Column(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "${AppUI.iconPath}Caht.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              text: 'Messages',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(
                              context, ProfileScreenAdmin(adminId: widget.adminId,));
                        },
                        child: const Column(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "${AppUI.iconPath}profile.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              text: 'Profile',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, MenuScreenAdmin(adminId: widget.adminId,));
                        },
                        child: const Column(
                          children: [
                            ImageIcon(
                              AssetImage(
                                "${AppUI.iconPath}menu.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              text: 'Menu',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.03),
                    child: Row(
                      children: [
                        // Conditionally show the "What's on your mind" field based on canPost
                        if (admin.canPost == true)
                          Row(
                            children: [
                              Image.asset(
                                '${AppUI.imgPath}photo.png',
                                height: 31.h,
                                width: 30.w,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              // Conditionally show the "What's on your mind" field based on canPost
                              if (admin.canPost == true)
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20.0)),
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: double.infinity,
                                      ),
                                      isScrollControlled: true,
                                      builder: (context) => CustomCard(
                                        height:
                                        MediaQuery.sizeOf(context).height * .8,
                                        radius: 20,
                                        child: CreatePost(apiManager: apiManager, onPostCreated: reloadPosts),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppUI.whiteColor),
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height:
                                    MediaQuery.of(context).size.height * 0.05,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 10.w),
                                        const Text(
                                          "What's on your mind",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppUI.buttonColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(width: 140.w),
                                        Image.asset(
                                          '${AppUI.iconPath}images.png',
                                          width: 12.w,
                                          height: 12.h,
                                        ),
                                        SizedBox(width: 10.w),
                                        Image.asset(
                                          '${AppUI.iconPath}point.png',
                                          width: 12.w,
                                          height: 12.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: 7),
                    child: FutureBuilder<List<Post>>(
                      future: adminPosts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No posts found'));
                        } else {
                          // Debugging: Print the length of the data
                          print('Number of posts: ${snapshot.data!.length}');
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Post post = snapshot.data![index];
                              return GestureDetector(
                                onLongPress: () async {
                                  bool? deleteOrEdit = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Choose Action'),
                                        content: const Text('Would you like to delete or edit this post?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false), // false indicates delete
                                            child: const Text('Delete'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true), // true indicates edit
                                            child: const Text('Edit'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(null), // null indicates cancel
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (deleteOrEdit == true) {
                                    final updatedPost = await _showEditDialog(context, post);
                                    if (updatedPost != null) {
                                      print(
                                          'Attempting to update post with ID: ${post
                                              .id}');

                                      await apiManager.updatePost(
                                          updatedPost.id,
                                          updatedPost.title ?? post.title!,
                                          updatedPost.content ?? post.content!);


                                    }
                                  } else if (deleteOrEdit == false) {
                                    // User chose to delete
                                    bool? confirmDelete = await showDialog<bool>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: const Text('Are you sure you want to delete this post?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmDelete == true) {
                                      print('Attempting to delete post with ID: ${post.id}');
                                      apiManager.deletePost(post.id);
                                      setState(() {
                                        adminPosts = apiManager.fetchAdminPosts();
                                      });
                                    }
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.85,
                                      decoration: BoxDecoration(
                                        color: AppUI.whiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ClipOval(
                                                  child: post.pictureLocationUser !=
                                                      null
                                                      ? CachedNetworkImage(
                                                    imageUrl:
                                                    'http://10.10.99.13:3090${post.pictureLocationUser}',
                                                    placeholder: (context,
                                                        url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget: (context,
                                                        url, error) =>
                                                        Icon(Icons.error),
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.05,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.08,
                                                    fit: BoxFit.cover,
                                                  )
                                                      : Image.asset(
                                                    '${AppUI.imgPath}photo.png',
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.05,
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.08,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.02,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                      0.01,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    CustomText(
                                                      text:
                                                      '${post.firstNameUser} ${post.lastNameUser}',
                                                      fontSize: 12,
                                                      color: AppUI.basicColor,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                    Row(
                                                      children: [
                                                        CustomText(
                                                          text: '${post.lastEdit}',
                                                          fontSize: 12,
                                                          color: AppUI.basicColor,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                              0.01,
                                                        ),
                                                        Image.asset(
                                                          '${AppUI.imgPath}Group.png',
                                                          height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                              0.015,
                                                          width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                              0.015,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.01,
                                            ),
                                            CustomText(
                                              text: post.content ?? "no content",
                                              fontSize: 10,
                                              color: AppUI.basicColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.01,
                                            ),
                                            if (post.pictureLocation != null) ...[
                                              CachedNetworkImage(
                                                imageUrl:
                                                'http://10.10.99.13:3090${post!.pictureLocation}',
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget: (context, url, error) =>
                                                    Icon(Icons.error),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.01,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height * 0.02,
                                    ),
                                  ],
                                ),

                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}