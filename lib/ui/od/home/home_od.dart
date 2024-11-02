import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spirit/ui/od/Menu/menu_od.dart';
import 'package:co_spirit/ui/od/Message/oppy_od.dart';
import 'package:co_spirit/ui/od/Notifactions/notifictions_od.dart';
import 'package:co_spirit/ui/od/opportunities/opportunities_od.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/Post.dart';
import '../Message/Message_od.dart';
import '../Profile/profile_od.dart';

class HomeScreenOD extends StatefulWidget {
  const HomeScreenOD({Key? key, required this.ODId}) : super(key: key);
  static String routeName = 'home screen admin';
  final String ODId;

  @override
  State<HomeScreenOD> createState() => _HomeScreenODState();
}

class _HomeScreenODState extends State<HomeScreenOD> {
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
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.25,
                child: SvgPicture.asset(
                  '${AppUI.svgPath}rectangle_od.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          '${AppUI.svgPath}corelia_logo.svg',
                          height: 28.h,
                          width: 100.w,
                          // fit: BoxFit.cover,
                        ),
                        InkWell(
                          onTap: () {
                            AppUtil.mainNavigator(
                              context,
                              const NotificationScreenOD(),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 13.w),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.25 * 0.10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(
                              context,
                              MenuScreenOD(
                                ODId: widget.ODId,
                              ));
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "${AppUI.svgPath}menu.svg",
                              width: 35,
                            ),
                            const CustomText(
                              text: 'Menu',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(
                              context, ProfileScreenOD(collaboratorId: widget.ODId));
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset("${AppUI.svgPath}profile.svg", width: 35),
                            const CustomText(
                              text: 'Profile',
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                              onTap: () =>
                                  AppUtil.mainNavigator(context, const OpportunitiesPageOD()),
                              child: SvgPicture.asset("${AppUI.svgPath}opportunity_icon.svg",
                                  width: 35)),
                          const SizedBox(height: 8),
                          const CustomText(
                            text: 'Opportunities',
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                     /* InkWell(
                        onTap: () => AppUtil.mainNavigator(context, OppyOD()),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "${AppUI.svgPath}oppy.svg",
                              width: 35,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const CustomText(
                              text: 'Oppy',
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),*/
                      InkWell(
                        onTap: () {
                          AppUtil.mainNavigator(context, const MessagesScreenOD());
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "${AppUI.svgPath}chat.svg",
                              width: 35,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const CustomText(
                              text: 'Messages',
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
              vertical: 7,
            ),
            child: RefreshIndicator(
              onRefresh: _reloadPosts,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<List<Post>>(
                      future: adminPosts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(color: ODColorScheme.buttonColor));
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
                                                  'http://${ApiConstants.baseUrl}${post.pictureLocation}',
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget: (context, url, error) =>
                                                  const Icon(Icons.error),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context).size.height * 0.01),
                                          ],
                                          const Divider(),
                                          const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.remove_red_eye,
                                                    size: 15,
                                                    color: ODColorScheme.buttonColor,
                                                  ),
                                                  Text(" 15", style: TextStyle(fontSize: 12)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.thumb_up_sharp,
                                                        size: 15,
                                                        color: ODColorScheme.buttonColor,
                                                      ),
                                                      Text(" 7    ",
                                                          style: TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.comment,
                                                        size: 15,
                                                        color: ODColorScheme.buttonColor,
                                                      ),
                                                      Text(" 19  ", style: TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.arrow_forward_outlined,
                                                        size: 15,
                                                        color: ODColorScheme.buttonColor,
                                                      ),
                                                      Text(" 3  ", style: TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
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
