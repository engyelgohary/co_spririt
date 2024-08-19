import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/data/api/apimanager.dart';
import 'package:co_spririt/ui/superadmin/Menu/menu_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Message/Message_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/superadmin/requests/request_Superadmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/model/Post.dart';
import 'creat_post.dart';

class HomeScreenSuperAdmin extends StatefulWidget {
  const HomeScreenSuperAdmin({Key? key}) : super(key: key);
  static String routeName = 'home screen super admin';

  @override
  State<HomeScreenSuperAdmin> createState() => _HomeScreenSuperAdminState();
}

class _HomeScreenSuperAdminState extends State<HomeScreenSuperAdmin> {
  late ApiManager apiManager;
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstanace();
    futurePosts = apiManager.fetchPosts();
  }

  void reloadPosts() {
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
                            AppUtil.mainNavigator(
                                context, const NotifactionScreenSuperAdmin());
                          },
                          child: Padding(
                            padding:
                            EdgeInsets.only(right:13.w),
                            child: Icon(
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
                            onTap: reloadPosts,
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
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, const RequestSuperAdmin());
                        },
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(
                                "${AppUI.iconPath}request.png",
                              ),
                              size: 24,
                              color: AppUI.borderColor,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            const CustomText(
                              text: 'Requests',
                              fontSize: 12,
                              color: AppUI.borderColor,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(
                              context, MessagesScreenSuperAdmin());
                        },
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(
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
                          AppUtil.mainNavigator(
                              context, const MenuScreenSuperAdmin());
                        },
                        child: Column(
                          children: [
                            ImageIcon(
                              const AssetImage(
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0)),
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
                                  child: CreatePost(apiManager: apiManager),
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
                                SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width * 0.02),
                                const Text(
                                  "What's in your mind",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppUI.buttonColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4),
                                Image.asset(
                                  '${AppUI.iconPath}images.png',
                                  width: MediaQuery.of(context).size.width * 0.03,
                                  height: MediaQuery.of(context).size.height * 0.03,
                                ),
                                SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width * 0.02),
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
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: 7),
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
                              return Column(
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
                                              Image.asset(
                                                '${AppUI.imgPath}photo.png',
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.05,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.08,
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.02,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text:
                                                    'User ID: ${post.userId}',
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
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.005,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.02,
                                  ),
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
        ]));
  }
}