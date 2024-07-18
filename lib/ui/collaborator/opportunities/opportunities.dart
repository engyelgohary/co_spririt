import 'package:co_spririt/data/dip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import 'addoportunities.dart';
import 'cubit/opportunities_cubit.dart';

class OpportunitiesScreenColla extends StatefulWidget {
  const OpportunitiesScreenColla({super.key});

  @override
  State<OpportunitiesScreenColla> createState() => _OpportunitiesScreenCollaState();
}

class _OpportunitiesScreenCollaState extends State<OpportunitiesScreenColla> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Opportunities",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),),
        leading: AppBarCustom(),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _showAddOpportunityDialog();
              },
              child: CircleAvatar(
                radius: 18.r, // Adjust the radius as needed
                backgroundColor: AppColor.secondColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOpportunityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => OpportunitiesCubit(opportunitiesRepository:injectOpportunitiesRepository()),
          child: AddOpportunities(),
        );
      },
    );
  }
}
