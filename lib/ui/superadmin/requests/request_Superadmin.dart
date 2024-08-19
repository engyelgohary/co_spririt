import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/data/model/Type.dart';
import 'package:co_spririt/ui/superadmin/requests/cubit/types_cubit.dart';
import 'package:co_spririt/ui/superadmin/requests/infoType.dart';
import 'package:co_spririt/ui/superadmin/requests/updateType.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/model/RequestsResponse.dart';
import '../../../utils/theme/appColors.dart';
import '../../collaborator/requests/cubit/requests_cubit.dart';
import '../adminforsuperadmin/infoAdmin.dart';
import 'AddType.dart';

class RequestSuperAdmin extends StatefulWidget {
  static const String routeName = 'Request Super admin';
  const RequestSuperAdmin({super.key});

  @override
  State<RequestSuperAdmin> createState() => _RequestSuperAdminState();
}

class _RequestSuperAdminState extends State<RequestSuperAdmin> {
  late TypesCubit viewModel;
  late RequestsCubit requestsCubit;
  @override
  void initState() {
    super.initState();
    viewModel = TypesCubit(typesRepository: injectTypesRepository());
    requestsCubit = RequestsCubit(requestsRepository: injectRequestsRepository(), typesRepository: injectTypesRepository(), adminRepository: injectAdminRepository(), collaboratorRepository: injectCollaboratorRepository());
  }
  @override
  void dispose() {
    viewModel.pagingController.dispose();
    super.dispose();
  }
  void onOpportunityAdded() {
    viewModel.pagingController.refresh();
  }
  Widget buildErrorIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(viewModel.pagingController.error.toString()),
          ElevatedButton(
            onPressed: () {
              viewModel.pagingController.refresh();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
        actions: [
          InkWell(
          onTap: () => showAddDialog(),
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        height: 60.h,
        width: 32.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.secondColor,
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
            child: Text("Types",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 18,fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => viewModel,
              child: BlocBuilder<TypesCubit, TypesState>(
                bloc: viewModel,
                builder: (context, state) {
                  return PagedListView<int, Types>.separated(
                    pagingController: viewModel.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Types>(
                      itemBuilder: (context, item, index) {
                        return Slidable(
                          startActionPane: ActionPane(
                            extentRatio: .22,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                borderRadius: BorderRadius.circular(20),
                                onPressed: (context) {
                                  viewModel.deleteType(item.id ?? 0);
                                },
                                backgroundColor: AppColor.errorColor,
                                foregroundColor: AppColor.whiteColor,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child:  ListTile(
                                        title: Padding(
                                          padding:  EdgeInsets.symmetric(vertical: 4.h),
                                          child: Text(item.type ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(fontSize: 18,fontWeight: FontWeight.w700)),
                                        ),
                                        trailing:Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showUpdateDialog(item);
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: AppColor.SkyColor,
                                                radius: 15.r,
                                                child: Icon(
                                                  Icons.update_outlined,
                                                  color: AppColor.secondColor,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            InkWell(
                                              onTap: () {
                                                showTypeDetailsBottomSheet(item.id ?? 0);
                                              },
                                              child: CircleAvatar(
                                                  backgroundColor: AppColor.SkyColor,
                                                  radius: 15.r,
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    color: AppColor.secondColor,
                                                    size: 15,
                                                  ),
                                                ),
                                            ),
                                          ],
                                        ),

                                      ),
                                    );
                      },
                      firstPageErrorIndicatorBuilder: buildErrorIndicator,
                      noItemsFoundIndicatorBuilder: (context) =>
                          Center(child: Text("No Clients found")),
                      newPageProgressIndicatorBuilder: (_) => Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(AppColor.secondColor),
                        ),
                      ),
                      firstPageProgressIndicatorBuilder: (_) => Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(AppColor.secondColor),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0,
                        color: AppColor.whiteColor,
                        thickness: 1,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => TypesCubit(typesRepository: injectTypesRepository()),
          child: AddStatusDialog(onOpportunityAdded: onOpportunityAdded,),
        );
        },
    );
  }
  void showTypeDetailsBottomSheet(int id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        viewModel.fetchTypeDetails(id);
        return BlocBuilder<TypesCubit, TypesState>(
          bloc: viewModel,
          builder: (context, state) {
            if (state is TypesSuccess) {
              if (state.typeData == null) {
                return Center(
                    child: CircularProgressIndicator(
                      color: AppColor.secondColor,
                    )); }
              return InfoType(state.typeData);
            } else if (state is TypesError) {
              return Center(child: Text(state.errorMessage??""));
            } else {
              return Center(child: CircularProgressIndicator(
                color: AppColor.secondColor,
              ));
            }
          },
        );
      },
    );
  }
  void showUpdateDialog(Types type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
         value: viewModel, child: UpdateType(type: type,),
        );
      },
    );
  }
}