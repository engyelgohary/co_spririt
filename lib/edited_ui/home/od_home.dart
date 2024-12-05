import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/Cubit/cubit_state.dart';
import '../../core/app_ui.dart';
import '../../core/components/appbar.dart';
import '../../data/edited_api/userprofile_apis.dart';
import '../forms/add_opportunity_form.dart';
import '../opportunities/od_opportunities.dart';
import '../scores/od_scores.dart';
import '../settings/cubit/settings_cubit.dart';
import '../settings/od_settings.dart';

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
    if (index == 2) {
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
                    _selectedIndex = 2; // Switch to the Settings tab
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
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldLogout == true) {
                    context.read<SettingsCubit>().logOut();
                  }
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

            Navigator.pushReplacementNamed(context, "lib/ui/auth/login.dart");

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
      ),
    );
  }
}
