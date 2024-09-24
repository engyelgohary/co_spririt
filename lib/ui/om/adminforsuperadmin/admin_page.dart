import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/ui/om/adminforsuperadmin/updateAdmin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../utils/components/appbar.dart';
import '../../../../utils/theme/appColors.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/dip.dart';
import '../../../data/model/GetAdmin.dart';
import 'Cubit/admin_cubit.dart';
import 'addAdminDialog.dart';
import 'infoAdmin.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminScreenForSuper extends StatefulWidget {
  @override
  State<AdminScreenForSuper> createState() => _AdminScreenForSuperState();
}

class _AdminScreenForSuperState extends State<AdminScreenForSuper> {
  late AdminCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AdminCubit(adminRepository: injectAdminRepository());
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
          'Admins',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 25.r,
              backgroundColor: AppColor.secondColor,
              child: const Icon(Icons.person_add_alt_outlined, color: AppColor.whiteColor, size: 20),
            ),
            onPressed: () {
              showAddBottomSheet();
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<AdminCubit, AdminState>(
          bloc: viewModel,
          builder: (context, state) {
            return PagedListView<int, GetAdmin>.separated(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<GetAdmin>(
                itemBuilder: (context, item, index) {
                  final adminImage = 'http://${ApiConstants.baseUrl}${item.pictureLocation}';
                  return Slidable(
                    startActionPane: ActionPane(
                      extentRatio: .22,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          onPressed: (context) {
                            context.read<AdminCubit>().deleteAdmin(item.id ?? 1);
                          },
                          backgroundColor: AppColor.errorColor,
                          foregroundColor: AppColor.whiteColor,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: adminImage,
                        placeholder: (context, url) => const CircularProgressIndicator(
                          color: AppColor.secondColor,
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: AppColor.SkyColor,
                          radius: 20.r,
                          child: const Icon(Icons.error_outline, color: AppColor.secondColor, size: 20),
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                        ),
                      ),
                      title: Text(
                        '${item.firstName} ${item.lastName}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        item.email ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              showUpdateAdminDialog(item);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18.r,
                              child: const Icon(
                                Icons.update_outlined,
                                color: AppColor.secondColor,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          InkWell(
                            onTap: () {
                              showAdminDetailsBottomSheet(item.id ?? 1);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18.r,
                              child: const Icon(
                                Icons.info_outline,
                                color: AppColor.secondColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: buildErrorIndicator,
                noItemsFoundIndicatorBuilder: (context) => const Center(child: Text("No Admins found")),
                newPageProgressIndicatorBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondColor),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.secondColor),
                  ),
                ),
              ),
              separatorBuilder: (context, index) {
                return const Divider(
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
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => AdminCubit(adminRepository: injectAdminRepository()),
          child: AddAdmin(
            onOpportunityAdded: onOpportunityAdded,
          ),
        );
      },
    );
  }

  void showUpdateAdminDialog(GetAdmin admin) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider.value(value: viewModel, child: UpdateAdminDialog(admin: admin));
      },
    );
  }

  void showAdminDetailsBottomSheet(int id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        viewModel.fetchAdminDetails(id);
        return BlocBuilder<AdminCubit, AdminState>(
          bloc: viewModel,
          builder: (context, state) {
            if (state is AdminSuccess) {
              if (state.adminData == null) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColor.secondColor,
                ));
              }
              return InfoAdmin(state.adminData);
            } else if (state is AdminError) {
              return Center(child: Text(state.errorMessage ?? ""));
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColor.secondColor,
              ));
            }
          },
        );
      },
    );
  }
}
