import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/components.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/ui/menu/om_menu.dart';
import 'package:co_spirit/ui/messages/om_message.dart';
import 'package:co_spirit/ui/notifications/om_notifications.dart';
import 'package:co_spirit/ui/oppy/oppy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/app_ui.dart';
import '../../../data/model/Post.dart';

class OMHomeScreen extends StatefulWidget {
  const OMHomeScreen({Key? key, required this.OMId}) : super(key: key);
  final String OMId;

  @override
  State<OMHomeScreen> createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<OMHomeScreen> {
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
                    '${AppUI.svgPath}rectangle_om.svg',
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
                              AppUtil.mainNavigator(
                                context,
                                const OMNotificationScreen(
                                  buttonColor: OMColorScheme.buttonColor,
                                  mainColor: OMColorScheme.mainColor,
                                ),
                              );
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
                              onTap: () => AppUtil.mainNavigator(context, const MenuScreenOM()),
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
                          // onTap: () => AppUtil.mainNavigator(context, const ProfileScreenOM()),

                          // onTap: () => snackBar(context, "Not implemented"),
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
                              // onTap: () => AppUtil.mainNavigator(context, const AllOpportunities()),
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
                              mainColor: OMColorScheme.mainColor,
                              buttonColor: OMColorScheme.buttonColor,
                              textColor: OMColorScheme.textColor,
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
                            AppUtil.mainNavigator(context, const MessagesScreenOM());
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
