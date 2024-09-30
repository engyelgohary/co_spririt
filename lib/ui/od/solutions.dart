import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/components.dart';

class Solutions extends StatefulWidget {
  const Solutions({Key? key}) : super(key: key);

  @override
  State<Solutions> createState() => _SolutionsState();
}

class _SolutionsState extends State<Solutions> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
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
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.message_outlined, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none_rounded, color: Color(0xFF000080)),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *0.75,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE), borderRadius: BorderRadius.circular(10)),                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height *0.16,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Solutions",style: TextStyle(color: Color(0xFF000080),fontSize: 18),),
                          SizedBox(height: 15.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton<String>(
                              value: null,
                              hint: Text(
                                "Select an option",
                                style: TextStyle(color: Colors.grey),
                              ),
                              isExpanded: true,
                              items: [],
                              onChanged: (value) {
                              },
                              dropdownColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),

                        ],
                      ),
                    ),

                  ),
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
