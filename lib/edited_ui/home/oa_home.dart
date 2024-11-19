import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/edited_ui/opportunities/oa_opportunities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';
import '../settings/oa_settings.dart';

class OAHomeScreen extends StatefulWidget {
  const OAHomeScreen({Key? key, required this.OAId}) : super(key: key);
  final String OAId;

  @override
  State<OAHomeScreen> createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<OAHomeScreen> {
  late ApiManager apiManager;
  int _selectedIndex = 0;

  void _openForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const Placeholder();
      },
    );
  }

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
        floatingActionButton: FloatingActionButton(
          onPressed: _openForm,
          backgroundColor: AppUI.oaMainColor,
          child: const Icon(Icons.add,color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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