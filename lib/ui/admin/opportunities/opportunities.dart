import 'package:flutter/material.dart';
import '../../../utils/components/appbar.dart';

class OpportunitiesScreenAdmin extends StatelessWidget {
  const OpportunitiesScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opportunities",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: AppBarCustom(),
      ),
    );
  }
}
