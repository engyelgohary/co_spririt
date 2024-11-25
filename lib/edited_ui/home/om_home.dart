import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/edited_ui/opportunities/om_opportunities.dart';
import 'package:co_spirit/edited_ui/settings/om_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';

class OMHomeScreen extends StatefulWidget {
  const OMHomeScreen({Key? key, required this.OMId}) : super(key: key);
  final String OMId;

  @override
  State<OMHomeScreen> createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<OMHomeScreen> {
  late ApiManager apiManager;

  int _selectedIndex = 3;


  final List<Widget> _pages = [
    Placeholder(),
    OmOpportunities(),
    Placeholder(),
    OmSettings(),
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
                      "assets/logos/om_logo.svg",
                      width: screenWidth * 0.5,
                    ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppUI.whiteColor,
          selectedItemColor:AppUI.omMainColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.developer_board),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Opportunities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              label: 'Users',
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