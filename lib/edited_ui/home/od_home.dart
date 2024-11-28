import 'package:co_spirit/core/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';
import '../forms/add_opprtunity_form.dart';
import '../settings/od_settings.dart';
import '../settings/cubit/settings_cubit.dart';
import '../../../data/edited_api/userprofile_apis.dart';
import '../opportunities/od_opportunities.dart';
import '../scores/od_scores.dart';

class ODHomeScreen extends StatefulWidget {
  const ODHomeScreen({Key? key}) : super(key: key);

  @override
  State<ODHomeScreen> createState() => _ODHomeScreenState();
}

class _ODHomeScreenState extends State<ODHomeScreen> {
  int _selectedIndex = 0;

  void _openForm() {
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

  late final List<Widget> _pages = [
    OdOpportunities(),
    OdScores(),
    BlocProvider(
      create: (context) => SettingsCubit(userProfileApis: UserProfileApis()),
      child: const OdSettings(),
    ),
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
            AppBarNew(context, "assets/logos/od_logo.svg"),
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
          child: const Icon(Icons.add, color: Colors.white),
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
