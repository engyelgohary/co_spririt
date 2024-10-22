import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/components.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/ui/menu/oa_menu.dart';
import 'package:co_spirit/ui/messages/message_screen.dart';
import 'package:co_spirit/ui/notifications/oa_notifications.dart';
import 'package:co_spirit/ui/opportunities/oa_opportunities.dart';
import 'package:co_spirit/ui/oppy/oppy.dart';
import 'package:co_spirit/ui/profile/oa_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/app_ui.dart';
import '../../../data/model/Post.dart';

class OAHomeScreen extends StatefulWidget {
  const OAHomeScreen({Key? key, required this.OAId}) : super(key: key);
  final String OAId;

  @override
  State<OAHomeScreen> createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<OAHomeScreen> {
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.21,
                  child: SvgPicture.asset(
                    '${AppUI.svgPath}rectangle_oa.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            '${AppUI.svgPath}corelia_logo.svg',
                            height: 28,
                            width: 100,
                          ),
                          InkWell(
                            onTap: () {
                              AppUtil.mainNavigator(context, const OANotificationScreen());
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 13),
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
                        Column(
                          children: [
                            InkWell(
                              onTap: () => AppUtil.mainNavigator(
                                  context,
                                  OAMenuScreen(
                                    OAId: widget.OAId,
                                  )),
                              child: SvgPicture.asset(
                                "${AppUI.svgPath}menu.svg",
                                width: 35,
                                semanticsLabel: "Menu",
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            const CustomText(
                              text: 'Menu',
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              AppUtil.mainNavigator(context, OAProfileScreen(OAId: widget.OAId)),
                          child: Column(
                            children: [
                              SvgPicture.asset("${AppUI.svgPath}profile.svg", width: 35),
                              const SizedBox(height: 8),
                              const CustomText(
                                text: 'Profile',
                                fontSize: 12,
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
                                  AppUtil.mainNavigator(context, const OpportunitiesPageOA()),
                              child: SvgPicture.asset("${AppUI.svgPath}opportunity_icon.svg",
                                  width: 35),
                            ),
                            const SizedBox(height: 8),
                            const CustomText(
                              text: 'Opportunities',
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => AppUtil.mainNavigator(
                            context,
                            OppyScreen(
                              mainColor: OAColorScheme.mainColor,
                              buttonColor: OAColorScheme.buttonColor,
                              textColor: OAColorScheme.textColor,
                            ),
                          ),
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
                        ),
                        InkWell(
                          onTap: () {
                            AppUtil.mainNavigator(
                                context,
                                const MessagesScreen(
                                  mainColor: OAColorScheme.mainColor,
                                  buttonColor: OAColorScheme.buttonColor,
                                  textColor: OAColorScheme.textColor,
                                ));
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "${AppUI.svgPath}chat.svg",
                                width: 35,
                              ),
                              SizedBox(
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
          ],
        ),
      ),
    );
  }
}
