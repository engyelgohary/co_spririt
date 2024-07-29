import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/admin/collaboratorsforadmin/Cubit/colloborator_to_admin_cubit.dart';
import 'package:co_spririt/ui/superadmin/collaboratorforsuperadmin/infoCollaborator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/model/Collaborator.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import '../../superadmin/adminforsuperadmin/Cubit/admin_cubit.dart';
import '../../superadmin/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';

class CollaboratorsAdminScreen extends StatefulWidget {

  @override
  State<CollaboratorsAdminScreen> createState() => _CollaboratorsAdminScreenState();
}

class _CollaboratorsAdminScreenState extends State<CollaboratorsAdminScreen> {
  late CollaboratorToAdminCubit collaboratorToAdminCubit;
  late CollaboratorCubit viewModel;
  late AdminCubit adminCubit;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collaborators',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
      ),
      body: BlocProvider.value(
        value: collaboratorToAdminCubit,
        child: BlocBuilder<CollaboratorToAdminCubit, CollaboratorToAdminState>(
          builder: (context, state) {
            return PagedListView<int, Collaborator>.separated(
              pagingController: collaboratorToAdminCubit.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Collaborator>(
                itemBuilder: (context, item, index) {
                  final adminImage =
                      'http://10.10.99.13:3090${item.pictureLocation}';
                    return ListTile(
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
                        "${item.email}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18.r,
                              child: Icon(
                                Icons.chat_outlined,
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
                              child: Icon(Icons.info_outline,
                                  color: AppColor.secondColor, size: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                },
              ),    separatorBuilder: (context, index) {
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
                  if (collaboratorState is CollaboratorSuccess &&
                      adminState is AdminSuccess) {
                    return InfoCollaborator(
                      collaborator: collaboratorState.collaboratorData,
                      admin: adminState.getAdmin ?? [],
                    );
                  } else if (collaboratorState is CollaboratorError) {
                    return Center(
                        child: Text(collaboratorState.errorMessage ?? ""));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                          color: AppColor.secondColor),
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

}
