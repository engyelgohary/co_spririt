import 'package:co_spirit/core/app_ui.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/ui/project_overview/projects_overview.dart';
import 'package:co_spirit/ui/raci/sm_raci_view.dart';
import 'package:co_spirit/ui/solutions/solutions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../sheets/new_project.dart';
import '../sheets/new_solution.dart';
import '../sheets/new_task.dart';
import '../sheets/new_target_service.dart';
import '../sheets/new_task_category.dart';
import '../sheets/new_team.dart';

class SMHomePage extends StatefulWidget {
  const SMHomePage({super.key});

  @override
  State<SMHomePage> createState() => _SMHomePageState();
}

class _SMHomePageState extends State<SMHomePage> {
  int pageIndex = 1;
  List pages = [
    const SMRACIViewPage(),
    const ProjectsOverview(isSm: true),
    const SolutionsScreen(),
    // const MenuScreenSM(ODId: "2")
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: SMColorScheme.background,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: false,
          title: Image.asset(
            '${AppUI.imgPath}new_logo.png',
          ),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset('${AppUI.svgPath}project_management/appbar/search.svg'),
                  SvgPicture.asset('${AppUI.svgPath}project_management/appbar/notifications.svg'),
                  SvgPicture.asset('${AppUI.svgPath}project_management/appbar/messages.svg'),
                ],
              ),
            )
          ],
          backgroundColor: SMColorScheme.bars,
        ),
        body: pages[pageIndex],
        floatingActionButton: PopupMenuButton(
          offset: pageIndex != 2 ? Offset(0, -130) : Offset(0, -40),
          color: Colors.white,
          itemBuilder: (context) {
            if (pageIndex == 2) {
              return <PopupMenuEntry>[
                const PopupMenuItem(
                  textStyle: TextStyle(color: SCColorScheme.mainColor),
                  value: 0,
                  child: Text(
                    'New Solution',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SCColorScheme.mainColor),
                  ),
                ),
                const PopupMenuItem(
                  textStyle: TextStyle(color: SCColorScheme.mainColor),
                  value: 1,
                  child: Text(
                    'New Target Service',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SCColorScheme.mainColor),
                  ),
                ),
              ];
            } else {
              return <PopupMenuEntry>[
                const PopupMenuItem(
                  textStyle: TextStyle(color: SCColorScheme.mainColor),
                  value: 0,
                  child: Text(
                    'New Project',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SCColorScheme.mainColor),
                  ),
                ),
                const PopupMenuItem(
                  textStyle: TextStyle(color: SCColorScheme.mainColor),
                  value: 1,
                  child: Text(
                    'New Task Category',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SCColorScheme.mainColor),
                  ),
                ),
                // const PopupMenuItem(
                //   value: 2,
                //   child: Text(
                //     'New Task',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(color: SCColorScheme.mainColor),
                //   ),
                // ),
                const PopupMenuItem(
                  value: 3,
                  child: Text(
                    "New Task",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SCColorScheme.mainColor),
                  ),
                ),
                const PopupMenuItem(
                  value: 4,
                  child: Text(
                    "New Team Members",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SCColorScheme.mainColor),
                  ),
                ),
              ];
            }
          },
          onSelected: (value) {
            if (pageIndex != 2) {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.90),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Icon(Icons.horizontal_rule_rounded),
                    ),
                    if (value == 0) const Flexible(child: NewProjectSheet()),
                    if (value == 1) const Flexible(child: NewTaskCategorySheet()),
                    if (value == 3) const Flexible(child: NewTaskSheet()),
                    if (value == 4) const Flexible(child: NewTeamSheet()),
                  ],
                ),
              );
            } else {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.90),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Icon(Icons.horizontal_rule_rounded),
                    ),
                    if (value == 0) const Flexible(child: NewSolution()),
                    if (value == 1) const Flexible(child: NewTargetService()),
                  ],
                ),
              );
            }
          },
          icon: FloatingActionButton(
            backgroundColor: SMColorScheme.background,
            onPressed: null,
            child: Icon(
              Icons.add,
              color: SMColorScheme.main,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: pageIndex,
          selectedItemColor: SMColorScheme.main,
          unselectedItemColor: SMColorScheme.second,
          items: [
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                '${AppUI.svgPath}project_management/navbar/raci.svg',
                colorFilter: const ColorFilter.mode(
                  SMColorScheme.main,
                  BlendMode.srcIn,
                ),
              ),
              icon: SvgPicture.asset('${AppUI.svgPath}project_management/navbar/raci.svg'),
              label: "RACI",
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                '${AppUI.svgPath}project_management/navbar/projects.svg',
                colorFilter: const ColorFilter.mode(
                  SMColorScheme.main,
                  BlendMode.srcIn,
                ),
              ),
              icon: SvgPicture.asset(
                '${AppUI.svgPath}project_management/navbar/projects.svg',
                colorFilter: ColorFilter.mode(
                  SMColorScheme.second,
                  BlendMode.srcIn,
                ),
              ),
              label: "Projects",
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                '${AppUI.svgPath}project_management/navbar/solutions.svg',
                colorFilter: const ColorFilter.mode(
                  SMColorScheme.main,
                  BlendMode.srcIn,
                ),
              ),
              icon: SvgPicture.asset('${AppUI.svgPath}project_management/navbar/solutions.svg'),
              label: "Solutions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            )
          ],
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
        ),
      ),
    );
  }
}
