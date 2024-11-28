import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/edited_ui/opportunities/ow_opportunities.dart';
import 'package:co_spirit/edited_ui/settings/ow_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';
import '../../core/components/appbar.dart';

class OWHomeScreen extends StatefulWidget {
  const OWHomeScreen({Key? key, required this.OWId}) : super(key: key);
  final String OWId;

  @override
  State<OWHomeScreen> createState() => _OWHomeScreenState();
}

class _OWHomeScreenState extends State<OWHomeScreen> {
  late ApiManager apiManager;

  int _selectedIndex = 1;

  final List<Widget> _pages = [
    OwOpportunities(),
    OwSettings(),
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
            AppBarNew(context, "assets/logos/ow_logo.svg"),
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
          selectedItemColor: AppUI.owMainColor,
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