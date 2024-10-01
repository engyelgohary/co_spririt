import 'package:co_spirit/ui/od/Message/Message_od.dart';
import 'package:co_spirit/ui/sm/menu.dart';
import 'package:co_spirit/ui/sm/solutions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/components.dart';

class RaciScreenSM extends StatefulWidget {
  const RaciScreenSM({Key? key}) : super(key: key);

  @override
  State<RaciScreenSM> createState() => _RaciScreenSMState();
}

class _RaciScreenSMState extends State<RaciScreenSM> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuScreen(ODId: "2")));
      return;
    }
    if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SolutionsScreen()));
      return;
    }
    if (index == 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagesScreenOD()));
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
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return RaciCard();
                },
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
