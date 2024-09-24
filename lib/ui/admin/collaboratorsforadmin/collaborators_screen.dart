import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/data/api/apimanager.dart';
import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/admin/collaboratorsforadmin/Cubit/colloborator_to_admin_cubit.dart';
import 'package:co_spririt/ui/om/collaboratorforsuperadmin/infoCollaborator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/app_util.dart';
import '../../../data/model/Collaborator.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import '../../om/adminforsuperadmin/Cubit/admin_cubit.dart';
import '../../om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import '../Message/chat_admin.dart';

class CollaboratorsAdminScreen extends StatefulWidget {
  const CollaboratorsAdminScreen({super.key});

  @override
  State<CollaboratorsAdminScreen> createState() => _CollaboratorsAdminScreenState();
}

class _CollaboratorsAdminScreenState extends State<CollaboratorsAdminScreen> {
  late CollaboratorToAdminCubit collaboratorToAdminCubit;
  late CollaboratorCubit viewModel;
  late AdminCubit adminCubit;

  @override
  void initState() {
    super.initState();
    collaboratorToAdminCubit = CollaboratorToAdminCubit(adminRepository: injectAdminRepository());
    viewModel = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
    adminCubit = AdminCubit(adminRepository: injectAdminRepository());
  }

  @override
  void dispose() {
    collaboratorToAdminCubit.pagingController.dispose();
    super.dispose();
  }

  void onOpportunityAdded() {
    collaboratorToAdminCubit.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collaborators',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
      ),
      body: BlocProvider.value(
        value: collaboratorToAdminCubit,
        child: BlocBuilder<CollaboratorToAdminCubit, CollaboratorToAdminState>(
          builder: (context, state) {
            return PagedListView<int, Collaborator>.separated(
              pagingController: collaboratorToAdminCubit.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Collaborator>(
                itemBuilder: (context, item, index) {
                  final adminImage = 'http://${ApiConstants.baseUrl}${item.pictureLocation}';
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: adminImage,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(color: AppColor.secondColor),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: AppColor.SkyColor,
                        radius: 20.r,
                        child:
                            const Icon(Icons.error_outline, color: AppColor.secondColor, size: 20),
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
                      "${item.email}",
                      overflow: TextOverflow.ellipsis,
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
                            AppUtil.mainNavigator(
                              context,
                              ChatScreenAdmin(
                                receiverId: item.id ?? 0,
                                email: item.email ?? "",
                                name: item.firstName ?? "",
                                pictureLocation: item.pictureLocation,
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColor.SkyColor,
                            radius: 18.r,
                            child: const Icon(
                              Icons.message_outlined,
                              color: AppColor.secondColor,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        InkWell(
                          onTap: () {
                            showStatusDialog(item.id ?? 0);
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColor.SkyColor,
                            radius: 18.r,
                            child: const Icon(
                              Icons.add_reaction_outlined,
                              color: AppColor.secondColor,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        InkWell(
                          onTap: () {
                            showCollaboratorDetailsBottomSheet(item.id ?? 1);
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColor.SkyColor,
                            radius: 18.r,
                            child: const Icon(Icons.info_outline,
                                color: AppColor.secondColor, size: 20),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: _getStatusColor(item.status), // Dynamic color based on status
                        ),
                      ],
                    ),
                  );
                },
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

  void showCollaboratorDetailsBottomSheet(int id) {
    viewModel.fetchCollaboratorDetails(id);
    adminCubit.fetchAdmins(1);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: viewModel),
            BlocProvider.value(value: adminCubit),
          ],
          child: BlocBuilder<CollaboratorCubit, CollaboratorState>(
            bloc: viewModel,
            builder: (context, collaboratorState) {
              return BlocBuilder<AdminCubit, AdminState>(
                bloc: adminCubit,
                builder: (context, adminState) {
                  if (collaboratorState is CollaboratorSuccess && adminState is AdminSuccess) {
                    return InfoCollaborator(
                      collaborator: collaboratorState.collaboratorData,
                      admin: adminState.getAdmin ?? [],
                    );
                  } else if (collaboratorState is CollaboratorError) {
                    return Center(child: Text(collaboratorState.errorMessage ?? ""));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColor.secondColor),
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void showStatusDialog(int collaboratorId) {
    showDialog(
      context: context,
      builder: (context) {
        int? selectedStatus;
        return AlertDialog(
          title: Text(
            'Select Status',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
          ),
          content: DropdownButton<int>(
            value: selectedStatus,
            onChanged: (int? newValue) {
              selectedStatus = newValue;
            },
            items: [
              DropdownMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Red',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 18,
                        color: AppColor.basicColor,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Green',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 18,
                        color: AppColor.basicColor,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Orange',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 18,
                        color: AppColor.basicColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              height: 35.h,
              width: 115.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Center(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 16,
                      color: AppColor.thirdColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.greyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.h,
              width: 115.w,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedStatus != null) {
                    collaboratorToAdminCubit.setStatusToCollaborator(
                        collaboratorId, selectedStatus!);
                    Navigator.of(context).pop();
                  }
                },
                child: Center(
                  child: Text(
                    'Set Status',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 16,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Color _getStatusColor(int? status) {
    switch (status) {
      case 1:
        return Colors.red; // Status 1 (Red)
      case 2:
        return Colors.green; // Status 2 (Green)
      case 3:
        return Colors.orange; // Status 3 (Orange)
      default:
        return Colors.grey; // Default color (Unknown status)
    }
  }

}
