import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/edited_ui/opportunities/om_opportunities.dart';
import 'package:co_spirit/edited_ui/settings/om_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';
import '../../core/components/appbar.dart';
import '../../data/edited_api/userprofile_apis.dart';
import '../../ui/auth/login.dart';
import '../forms/oppy_configurations/configurations_screen.dart';
import '../settings/cubit/settings_cubit.dart';

class OMHomeScreen extends StatefulWidget {
  const OMHomeScreen({Key? key}) : super(key: key);

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
    BlocProvider(
      create: (context) => SettingsCubit(userProfileApis: UserProfileApis()),
      child: const OmSettings(),
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // When "Settings" is tapped, show the bottom sheet
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context); // Close the sheet
                  setState(() {
                    _selectedIndex = 3; // Switch to the Settings tab
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_suggest),
                title: const Text("Configurations"),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ConfigurationScreen()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet

                  // Show confirmation dialog before logging out
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Confirm Logout"),
                        content:
                        const Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await context.read<SettingsCubit>().logOut();
                              Navigator.pop(context, true); // Close the logout confirmation dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },


                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header
            AppBarNew(context, "assets/logos/om_logo.svg"),

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