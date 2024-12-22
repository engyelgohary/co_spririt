import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/edited_ui/opportunities/oa_opportunities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/app_ui.dart';
import '../../core/Cubit/cubit_state.dart';
import '../../core/app_util.dart';
import '../../core/theme/app_colors.dart';
import '../../data/edited_api/userprofile_apis.dart';
import '../../ui/auth/login.dart';
import '../../ui/oppy/oppy.dart';
import '../settings/cubit/settings_cubit.dart';
import '../settings/oa_settings.dart';

class OAHomeScreen extends StatefulWidget {
  const OAHomeScreen({Key? key}) : super(key: key);

  @override
  State<OAHomeScreen> createState() => _OAHomeScreenState();
}

class _OAHomeScreenState extends State<OAHomeScreen> {
  late ApiManager apiManager;
  int _selectedIndex = 1;


  final List<Widget> _pages = [
    OaOpportunities(),
    BlocProvider(
      create: (context) => SettingsCubit(userProfileApis: UserProfileApis()),
      child: const OaSettings(),
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
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
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context); // Close the sheet
                  setState(() {
                    _selectedIndex = 1; // Switch to the Settings tab
                  });
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
    return BlocListener<SettingsCubit, CubitState>(
        listener: (context, state) {
      if (state is CubitLoadingState) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is CubitSuccessState) {
        // Close loading indicator
        Navigator.pop(context);

        // Perform navigation to the login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (state is CubitFailureState) {
        // Close loading indicator
        Navigator.pop(context);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error)),
        );
      }
    },
    child: SafeArea(
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
    ),);
  }
}