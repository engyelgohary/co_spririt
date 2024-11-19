import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/edited_ui/opportunities/od_opportunities.dart';
import 'package:co_spirit/edited_ui/scores/od_scores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';
import '../forms/add_opprtunity_form.dart';
import '../settings/od_settings.dart';

class ODHomeScreen extends StatefulWidget {
  const ODHomeScreen({Key? key, required this.ODId}) : super(key: key);
  final String ODId;

  @override
  State<ODHomeScreen> createState() => _OMHomeScreenState();
}

class _OMHomeScreenState extends State<ODHomeScreen> {
  late ApiManager apiManager;

  int _selectedIndex = 0;

  void _openForm() {
    // Open form when floating action button is pressed
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const OpportunityForm();
      },
    );
  }

  final List<Widget> _pages = [
    OdOpportunities(),
    OdScores(),
    OdSettings(),
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
                      "assets/logos/test.svg",
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
          backgroundColor: Colors.green,
          child: const Icon(Icons.add,color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppUI.whiteColor,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Opportunities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Score',
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