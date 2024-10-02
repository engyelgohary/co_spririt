import 'package:co_spirit/ui/sc/RACI.dart';
import 'package:co_spirit/ui/sc/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/components.dart';

class SolutionsScreenSC extends StatefulWidget {
  const SolutionsScreenSC({Key? key}) : super(key: key);

  @override
  State<SolutionsScreenSC> createState() => _SolutionsScreenSCState();
}

class _SolutionsScreenSCState extends State<SolutionsScreenSC> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const MenuScreenSC(ODId: "2")));
      return;
    }

    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RaciOverviewSC()));
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 28.0, 15.0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/logo-corelia.png",
                  width: 110.w,
                  height: 56.h,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message_outlined, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF000080)),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * 0.16,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Solutions",
                            style: TextStyle(color: Color(0xFF000080), fontSize: 18),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton<String>(
                              value: null,
                              hint: const Text(
                                "Select an option",
                                style: TextStyle(color: Colors.grey),
                              ),
                              isExpanded: true,
                              items: [],
                              onChanged: (value) {},
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Row(children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("data")],
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
