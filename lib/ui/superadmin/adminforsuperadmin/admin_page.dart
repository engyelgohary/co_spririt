import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../utils/components/appbar.dart';
import '../../../../utils/theme/appColors.dart';
import '../../../data/dip.dart';
import '../../../data/model/GetAdmin.dart';
import 'Cubit/add_admin_cubit.dart';
import 'addAdminDialog.dart';

class AdminScreenForSuper extends StatefulWidget {
  @override
  State<AdminScreenForSuper> createState() => _AdminScreenForSuperState();
}

class _AdminScreenForSuperState extends State<AdminScreenForSuper> {
  late AddAdminCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AddAdminCubit(authRepository: injectAuthRepository());
  }

  @override
  void dispose() {
    viewModel.pagingController.dispose();
    super.dispose();
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
          'Admins',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 25.r,
              backgroundColor: AppColor.secondColor,
              child: Icon(Icons.person_add_alt_outlined, color: AppColor.whiteColor, size: 20),
            ),
            onPressed: () {
              showAddBottomSheet();
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<AddAdminCubit, AddAdminState>(
          bloc: viewModel,
          builder: (context, state) {
            return PagedListView<int, GetAdmin>.separated(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<GetAdmin>(
                itemBuilder: (context, item, index) {
                  final adminImage = 'http://10.10.99.13:3090${item.pictureLocation}';
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: adminImage,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: AppColor.SkyColor,
                        radius: 20.r,
                        child: Icon(Icons.error_outline, color: AppColor.secondColor, size: 20),
                      ),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),
                    title: Text(
                      item.firstName ?? "",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      item.email ?? "",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.SkyColor,
                          radius: 18.r,
                          child: Icon(
                            Icons.update_outlined,
                            color: AppColor.secondColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        CircleAvatar(
                          backgroundColor: AppColor.SkyColor,
                          radius: 18.r,
                          child: Icon(
                            Icons.info_outline,
                            color: AppColor.secondColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: buildErrorIndicator,
                noItemsFoundIndicatorBuilder: (context) => Center(child: Text("No Admins found")),
                newPageProgressIndicatorBuilder: (_) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondColor),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondColor),
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
    );
  }

  void showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: FractionallySizedBox(
            heightFactor: 1,
            child: AddAdmin(),
          ),
        );
      },
    );
  }
}


