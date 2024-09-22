
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/data/api/apimanager.dart';
import 'package:co_spririt/ui/superadmin/Menu/menu_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Message/Message_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictions_superadmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/model/Post.dart';
import '../../admin/opportunities/opportunities_v2.dart';
import 'creat_post.dart';

class HomeScreenSuperAdmin extends StatefulWidget {
  const HomeScreenSuperAdmin({Key? key, required this.superAdminId}) : super(key: key);
  static String routeName = 'home screen super admin';
  final String superAdminId;

  @override
  State<HomeScreenSuperAdmin> createState() => _HomeScreenSuperAdminState();
}

class _HomeScreenSuperAdminState extends State<HomeScreenSuperAdmin> {
  late ApiManager apiManager;
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstance();
    futurePosts = apiManager.fetchPosts();
  }

  Future<void> _reloadPosts() async {
    setState(() {
      futurePosts = apiManager.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 50.h,
              ),
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
                        AppUtil.mainNavigator(context, const NotificationScreenSuperAdmin());
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
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      InkWell(
                          onTap: () => AppUtil.mainNavigator(context, const OpportunitiesV2()),
                          child: const Icon(Icons.lightbulb_outline)),
                      const SizedBox(height: 8),
                      const CustomText(
                        text: 'Opportunity',
                        fontSize: 12,
                        color: AppUI.secondColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: _reloadPosts,
                        child: const ImageIcon(
                          AssetImage("${AppUI.iconPath}Home.png"),
                          size: 24,
                          color: AppUI.secondColor,
                          semanticLabel: 'Home',
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      const CustomText(
                        text: 'Home',
                        fontSize: 12,
                        color: AppUI.secondColor,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     AppUtil.mainNavigator(context, const RequestSuperAdmin());
                  //   },
                  //   child: Column(
                  //     children: [
                  //       ImageIcon(
                  //         const AssetImage(
                  //           "${AppUI.iconPath}request.png",
                  //         ),
                  //         size: 24,
                  //         color: AppUI.borderColor,
                  //       ),
                  //       SizedBox(
                  //         height: 8.h,
                  //       ),
                  //       const CustomText(
                  //         text: 'Requests',
                  //         fontSize: 12,
                  //         color: AppUI.borderColor,
                  //         fontWeight: FontWeight.w400,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      AppUtil.mainNavigator(context, const MessagesScreenSuperAdmin());
                    },
                    child: Column(
                      children: [
                        const ImageIcon(
                          AssetImage(
                            "${AppUI.iconPath}Caht.png",
                          ),
                          size: 24,
                          color: AppUI.borderColor,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        const CustomText(
                          text: 'Messages',
                          fontSize: 12,
                          color: AppUI.borderColor,
                          fontWeight: FontWeight.w400,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppUtil.mainNavigator(context, const MenuScreenSuperAdmin());
                    },
                    child: Column(
                      children: [
                        const ImageIcon(
                          AssetImage(
                            "${AppUI.iconPath}menu.png",
                          ),
                          size: 24,
                          color: AppUI.borderColor,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        const CustomText(
                          text: 'Menu',
                          fontSize: 12,
                          color: AppUI.borderColor,
                          fontWeight: FontWeight.w400,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: _reloadPosts,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Row(
                    children: [
                      Image.asset(
                        '${AppUI.imgPath}photo.png',
                        height: 31.h,
                        width: 30.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                            ),
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.8,
                            ),
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomCard(
                                height: MediaQuery.of(context).size.height * 0.8,
                                radius: 20,
                                child:
                                    CreatePost(apiManager: apiManager, onPostCreated: _reloadPosts),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppUI.whiteColor,
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                              const Text(
                                "What's in your mind",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppUI.buttonColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.4),
                              Image.asset(
                                '${AppUI.iconPath}images.png',
                                width: MediaQuery.of(context).size.width * 0.03,
                                height: MediaQuery.of(context).size.height * 0.03,
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                              Image.asset(
                                '${AppUI.iconPath}point.png',
                                width: MediaQuery.of(context).size.width * 0.03,
                                height: MediaQuery.of(context).size.height * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03, vertical: 7),
                  child: FutureBuilder<List<Post>>(
                    future: futurePosts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No posts found'));
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Post post = snapshot.data![index];

                            // Check if both firstNameUser and lastNameUser are null
                            if (post.firstNameUser == null && post.lastNameUser == null) {
                              // Delete the post if user ID is not found
                              apiManager.deletePost(post.id);
                              return const SizedBox
                                  .shrink(); // Return an empty widget to avoid rendering this post
                            }

                            return Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.85,
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
                                              child: post.firstNameUser == null &&
                                                      post.lastNameUser == null
                                                  ? Image.asset(
                                                      '${AppUI.imgPath}user_not_found.png', // Replace with your 'User not found' image path
                                                      height:
                                                          MediaQuery.of(context).size.height * 0.05,
                                                      width:
                                                          MediaQuery.of(context).size.width * 0.08,
                                                    )
                                                  : post.pictureLocationUser == null
                                                      ? Image.asset(
                                                          '${AppUI.imgPath}photo.png',
                                                          height:
                                                              MediaQuery.of(context).size.height *
                                                                  0.05,
                                                          width: MediaQuery.of(context).size.width *
                                                              0.08,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              'http://${ApiConstants.baseUrl}${post.pictureLocationUser}',
                                                          placeholder: (context, url) =>
                                                              const CircularProgressIndicator(),
                                                          errorWidget: (context, url, error) =>
                                                              const Icon(Icons.error),
                                                          height:
                                                              MediaQuery.of(context).size.height *
                                                                  0.05,
                                                          width: MediaQuery.of(context).size.width *
                                                              0.08,
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.02,
                                              height: MediaQuery.of(context).size.height * 0.01,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post.firstNameUser != null &&
                                                          post.lastNameUser != null
                                                      ? '${post.firstNameUser} ${post.lastNameUser}'
                                                      : 'User not found',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: post.firstNameUser != null &&
                                                            post.lastNameUser != null
                                                        ? AppUI.basicColor
                                                        : Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    decoration: post.firstNameUser != null &&
                                                            post.lastNameUser != null
                                                        ? TextDecoration.none
                                                        : TextDecoration.lineThrough,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    CustomText(
                                                      text: '${post.lastEdit}',
                                                      fontSize: 12,
                                                      color: AppUI.basicColor,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context).size.width * 0.01,
                                                    ),
                                                    Image.asset(
                                                      '${AppUI.imgPath}Group.png',
                                                      height: MediaQuery.of(context).size.height *
                                                          0.015,
                                                      width:
                                                          MediaQuery.of(context).size.width * 0.015,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () async {
                                                bool? delete = await showDialog<bool>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Choose Action'),
                                                      content: const Text(
                                                          'Would you like to delete this post?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(context).pop(true),
                                                          child: const Text('Delete'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(context).pop(false),
                                                          child: const Text('Cancel'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                if (delete == true) {
                                                  try {
                                                    await apiManager.deletePost(post.id);
                                                    setState(() {
                                                      futurePosts = apiManager.fetchPosts();
                                                    });
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                          content:
                                                              Text('Failed to delete post: $e')),
                                                    );
                                                  }
                                                }
                                              },
                                              icon: const Icon(Icons.more_vert_rounded),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                        CustomText(
                                          text: post.content ?? "no content",
                                          fontSize: 10,
                                          color: AppUI.basicColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                        if (post.pictureLocation != null) ...[
                                          CachedNetworkImage(
                                            imageUrl:
                                                'http://${ApiConstants.baseUrl}${post.pictureLocation}',
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.01),
                                        ],
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.005),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                              ],
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
        ),
      ),
    ]));
  }
}
