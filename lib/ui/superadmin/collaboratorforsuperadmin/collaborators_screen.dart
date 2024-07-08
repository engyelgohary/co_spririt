import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/ui/superadmin/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/dip.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';

class CollaboratorsScreenForSuper extends StatefulWidget {
  const CollaboratorsScreenForSuper({super.key});
  @override
  State<CollaboratorsScreenForSuper> createState() =>
      _CollaboratorsScreenForSuperState();
}

class _CollaboratorsScreenForSuperState
    extends State<CollaboratorsScreenForSuper> {
  late CollaboratorCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CollaboratorCubit(
        collaboratorRepository: injectCollaboratorRepository());
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
          'Collaborators',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 25.r,
              backgroundColor: AppColor.secondColor,
              child: Icon(Icons.person_add_alt_outlined,
                  color: AppColor.whiteColor, size: 20),
            ),
            onPressed: () {
              // showAddBottomSheet();
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: viewModel,
        child: BlocBuilder<CollaboratorCubit, CollaboratorState>(
          builder: (context, state) {
            return PagedListView<int, Collaborator>.separated(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Collaborator>(
                itemBuilder: (context, item, index) {
                  final adminImage =
                      'http://10.10.99.13:3090${item.pictureLocation}';
                  return Slidable(
                    startActionPane: ActionPane(
                      extentRatio: .22,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          onPressed: (context) {
                            context
                                .read<CollaboratorCubit>()
                                .deleteCollaborator(item.id ?? 1);
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
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                                color: AppColor.secondColor),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: AppColor.SkyColor,
                          radius: 20.r,
                          child: Icon(Icons.error_outline,
                              color: AppColor.secondColor, size: 20),
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
                        "${item.adminId}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              // showUpdateAdminDialog(item);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18.r,
                              child: Icon(
                                Icons.update_outlined,
                                color: AppColor.secondColor,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          InkWell(
                            onTap: () {
                              // showAdminDetailsBottomSheet(item.id ?? 1);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18.r,
                              child: Icon(Icons.info_outline,
                                  color: AppColor.secondColor, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: buildErrorIndicator,
                noItemsFoundIndicatorBuilder: (context) =>
                    Center(child: Text("No Admins found")),
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
    );
  }
}
