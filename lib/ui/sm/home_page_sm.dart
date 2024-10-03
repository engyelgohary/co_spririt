import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';

class HomePageSm extends StatefulWidget {
  final String SMId;
  const HomePageSm({super.key, required this.SMId});

  @override
  State<HomePageSm> createState() => _HomePageSmState();
}

class _HomePageSmState extends State<HomePageSm> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: selected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                label: 'Projects',
                tooltip: "Projects",
              ),
              NavigationDestination(
                icon: Icon(Icons.task_outlined),
                label: 'Tasks',
                tooltip: 'Tasks',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.lightbulb),
                icon: Icon(Icons.lightbulb_outline),
                label: 'Solution',
                tooltip: 'Solution',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.lightbulb),
                icon: Icon(Icons.lightbulb_outline),
                label: 'Solution',
                tooltip: 'Solution',
              ),
            ],
            onDestinationSelected: (value) => setState(() {
              selected = value;
            }),
          ),
          body: Text("data")),
    );
  }
}
