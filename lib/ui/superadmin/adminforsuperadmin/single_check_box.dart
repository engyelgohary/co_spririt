import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';



class SingleCheckBox extends StatefulWidget {
  final List<bool> isSelectedList;

  const SingleCheckBox({required this.isSelectedList});

  @override
  State<SingleCheckBox> createState() => _SingleCheckBoxState();
}

class _SingleCheckBoxState extends State<SingleCheckBox> {
  late List<bool> _isSelectedList;
  int selectId = 0;

  @override
  void initState() {
    super.initState();
    _isSelectedList = [
      false,
      false,
    ];
    // _isSelectedList = List<bool>.from(widget.isSelectedList);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildOption("Yes", 1),
        buildOption("No", 0),

      ],
    );
  }

  Widget buildOption(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _updateSelection(index);
        });
      },
      
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isSelectedList.isNotEmpty && // selectId==index //
                _isSelectedList[index]
                ? const Icon(
              Icons.check_box,
              color: AppUI.basicColor,
            )
                : const Icon(Icons.check_box_outline_blank,
                color: AppUI.borderColor),
            Text(title),
            SizedBox(width: 55,),

          ],
        ),
      )
    );
  }

  void _updateSelection(int selectedIndex) {
    print("Before update: $_isSelectedList");
    setState(() {
      if (_isSelectedList.isNotEmpty) {
        selectId = selectedIndex;
        print("selectedIndex 0----");
        print(selectId);
        _isSelectedList = List.generate(
            //  _isSelectedList.length, (index) => index == selectedIndex);
            _isSelectedList.length,
            (index) => index == selectedIndex);
        // _isSelectedList.length, (index) => index == selectedIndex);
      }
    });
    print("After update: $_isSelectedList");
  }
}
