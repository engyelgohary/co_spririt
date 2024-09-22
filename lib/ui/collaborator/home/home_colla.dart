import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/ui/admin/opportunities/opportunities_v2.dart';
import 'package:co_spririt/ui/collaborator/Menu/menu_collaborator.dart';
import 'package:co_spririt/ui/collaborator/Notifactions/notifictions_collaborator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/Post.dart';
import '../Message/Message_colla.dart';
import '../Profile/profile_collabrator.dart';

class HomeScreenColla extends StatefulWidget {
  HomeScreenColla({Key? key, required this.CollaboratorId}) : super(key: key);
  static String routeName = 'home screen admin';
  final String CollaboratorId;

  @override
  State<HomeScreenColla> createState() => _HomeScreenCollaState();
}

class _HomeScreenCollaState extends State<HomeScreenColla> {
  late ApiManager apiManager;
  late Future<List<Post>> adminPosts;

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstance();
    adminPosts = apiManager.fetchAdminPosts();
  }

  Future<void> _reloadPosts() async {
    setState(() {
      adminPosts = apiManager.fetchAdminPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
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
                          // fit: BoxFit.cover,
                        ),
                        InkWell(
                          onTap: () {
                            AppUtil.mainNavigator(
                              context,
                              const NotificationScreenCollaborator(),
                            );
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
                  const SizedBox(
                    height: 12,
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
                      const Column(
                        children: [
                          ImageIcon(
                            AssetImage(
                              "${AppUI.iconPath}Home.png",
                            ),
                            size: 24,
                            color: AppUI.secondColor,
                            semanticLabel: 'Home',
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CustomText(
                            text: 'Home',
                            fontSize: 12,
                            color: AppUI.secondColor,
                            fontWeight: FontWeight.w400,
                          )
                        ],
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     AppUtil.mainNavigator(context, RequestCollaborator());
                      //   },
                      //   child: const Column(
                      //     children: [
                      //       ImageIcon(
                      //         AssetImage(
                      //           "${AppUI.iconPath}request.png",
                      //         ),
                      //         size: 24,
                      //         color: AppUI.borderColor,
                      //       ),
                      //       SizedBox(
                      //         height: 8,
                      //       ),
                      //       CustomText(
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
                          AppUtil.mainNavigator(context, const MessagesScreenColla());
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
                            SizedBox(
                              height: 8,
                            ),
                            CustomText(
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
                              context,
                              ProfileScreenColla(
                                collaboratorId: widget.CollaboratorId,
                              ));
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
                            SizedBox(
                              height: 8,
                            ),
                            CustomText(
                              text: 'Profile',
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
                              context,
                              MenuScreenCollaborators(
                                CollaboratorId: widget.CollaboratorId,
                              ));
                        },
                        child: const Column(
                          children: [
                            ImageIcon(
                                AssetImage(
                                  "${AppUI.iconPath}menu.png",
                                ),
                                size: 24,
                                color: AppUI.borderColor),
                            SizedBox(
                              height: 8,
                            ),
                            CustomText(
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
                    FutureBuilder<List<Post>>(
                      future: adminPosts,
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
                                    width: screenWidth * 0.85,
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
                                                child: post.pictureLocationUser != null
                                                    ? CachedNetworkImage(
                                                        imageUrl:
                                                            'http://${ApiConstants.baseUrl}${post.pictureLocationUser}',
                                                        placeholder: (context, url) =>
                                                            const CircularProgressIndicator(),
                                                        errorWidget: (context, url, error) =>
                                                            const Icon(Icons.error),
                                                        height: MediaQuery.of(context).size.height *
                                                            0.05,
                                                        width: MediaQuery.of(context).size.width *
                                                            0.08,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        '${AppUI.imgPath}photo.png',
                                                        height: MediaQuery.of(context).size.height *
                                                            0.05,
                                                        width: MediaQuery.of(context).size.width *
                                                            0.08,
                                                      ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.02,
                                                height: MediaQuery.of(context).size.height * 0.01,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width *
                                                            0.01,
                                                      ),
                                                      Image.asset(
                                                        '${AppUI.imgPath}Group.png',
                                                        height: MediaQuery.of(context).size.height *
                                                            0.015,
                                                        width: MediaQuery.of(context).size.width *
                                                            0.015,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.01),
                                          CustomText(
                                            text: post.content ?? "no content",
                                            fontSize: 10,
                                            color: AppUI.basicColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.01),
                                          if (post.pictureLocation != null) ...[
                                            CachedNetworkImage(
                                              imageUrl:
                                                  'http://${ApiConstants.baseUrl}${post!.pictureLocation}',
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget: (context, url, error) =>
                                                  const Icon(Icons.error),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.01),
                                          ],
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
