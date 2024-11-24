import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/edited_ui/opportunities/oa_opportunities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';
import '../../core/app_util.dart';
import '../../core/theme/app_colors.dart';
import '../../ui/oppy/oppy.dart';
import '../settings/oa_settings.dart';

class OAHomeScreen extends StatefulWidget {
  const OAHomeScreen({Key? key, required this.OAId}) : super(key: key);
  final String OAId;

  @override
  State<OAHomeScreen> createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<OAHomeScreen> {
  late ApiManager apiManager;
  int _selectedIndex = 1;


  final List<Widget> _pages = [
    OaOpportunities(),
    OaSettings(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header
            Container(
              width: screenWidth,
              color: AppUI.whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/logos/oa_logo.svg",
                      width: screenWidth * 0.5,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(onPressed: (){AppUtil.mainNavigator(
                      context,
                      const OppyScreen(
                        mainColor: OAColorScheme.mainColor,
                        buttonColor: OAColorScheme.buttonColor,
                        textColor: OAColorScheme.textColor,
                      ),
                    );},
                      icon: SvgPicture.asset(
                      "assets/icons/svg/ask_oppy.svg",
                      width: screenWidth * 0.08,
                    ),),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppUI.whiteColor,
          selectedItemColor: AppUI.oaMainColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Opportunities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),

      ),
    );
  }
}