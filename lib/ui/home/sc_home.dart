import 'package:co_spirit/core/app_ui.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/ui/project_overview/projects_overview.dart';
import 'package:co_spirit/ui/raci/sc_raci_view.dart';
import 'package:co_spirit/ui/solutions/solutions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SCHomePage extends StatefulWidget {
  const SCHomePage({super.key});

  @override
  State<SCHomePage> createState() => _SCHomePageState();
}

class _SCHomePageState extends State<SCHomePage> {
  int pageIndex = 1;
  List pages = [
    const SCRACIViewPage(),
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
