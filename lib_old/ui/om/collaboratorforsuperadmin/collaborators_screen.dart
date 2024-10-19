import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spirit/data/model/Client.dart';
import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:co_spirit/data/model/admin.dart';
import 'package:co_spirit/ui/om/adminforsuperadmin/Cubit/admin_cubit.dart';
import 'package:co_spirit/ui/om/clientsForSuperAdmin/Cubit/client_cubit.dart';
import 'package:co_spirit/ui/om/collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';
import 'package:co_spirit/ui/om/collaboratorforsuperadmin/infoCollaborator.dart';
import 'package:co_spirit/ui/om/collaboratorforsuperadmin/updateCollaborator.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/api/apimanager.dart';
import '../../../data/dip.dart';
import '../../../utils/theme/appColors.dart';
import 'addCollaborator.dart';

class CollaboratorsScreenForSuper extends StatefulWidget {
  const CollaboratorsScreenForSuper({super.key});

  @override
  State<CollaboratorsScreenForSuper> createState() => _CollaboratorsScreenForSuperState();
}

class _CollaboratorsScreenForSuperState extends State<CollaboratorsScreenForSuper> {
  late CollaboratorCubit viewModel;
  List<Admin> admins = [];
  bool isLoading = true;
  String? selectedClientId;
  late AdminCubit adminCubit;
  late ClientCubit clientCubit;

  @override
  void initState() {
    super.initState();
    viewModel = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
    adminCubit = AdminCubit(adminRepository: injectAdminRepository());
    clientCubit = ClientCubit(clientRepository: injectClientRepository());
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
      appBar: customAppBar(
        title: "Opportunity Detectors",
        context: context,
        backArrowColor: OMColorScheme.mainColor,
        textColor: OMColorScheme.textColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.person_add_alt_outlined, size: 20),
              onPressed: () {
                showAddBottomSheet();
              },
            ),
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
                  final adminImage = 'http://${ApiConstants.baseUrl}${item.pictureLocation}';
                  return Slidable(
                    startActionPane: ActionPane(
                      extentRatio: .22,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          onPressed: (context) {
                            context.read<CollaboratorCubit>().deleteCollaborator(item.id ?? 1);
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
                            const CircularProgressIndicator(color: AppColor.secondColor),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: AppColor.SkyColor,
                          radius: 20,
                          child: const Icon(Icons.error_outline,
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
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<int>(
                            offset: Offset(0, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            icon: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18,
                              child: const Icon(
                                Icons.person_add_outlined,
                                color: AppColor.secondColor,
                                size: 20,
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text("Assign to admin",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: AppColor.borderColor, fontSize: 12)),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text("Assign to Client",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: AppColor.borderColor, fontSize: 12)),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 1) {
                                showAssignToAdminDialog(item.id ?? 1);
                              } else if (value == 2) {
                                showAssignToClientDialog(item.id ?? 1);
                              }
                            },
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              showUpdateCollaboratorDialog(item);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18,
                              child: const Icon(
                                Icons.update_outlined,
                                color: AppColor.secondColor,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              showCollaboratorDetailsBottomSheet(item.id ?? 1);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18,
                              child: const Icon(Icons.info_outline,
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
                    const Center(child: Text("No Collaborators found")),
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
          create: (context) =>
              CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository()),
          child: Addcollaborator(
            onOpportunityAdded: onOpportunityAdded,
          ),
        );
      },
    );
  }

  void showUpdateCollaboratorDialog(Collaborator collaborator) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider.value(
            value: viewModel,
            child: Updatecollaborator(
              collaborator: collaborator,
            ));
      },
    );
  }

  void showCollaboratorDetailsBottomSheet(int id) {
    viewModel.fetchCollaboratorDetails(id);
    adminCubit.fetchAdmins(1); // Fetch admins when showing collaborator details
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

  void showAssignToAdminDialog(int collaboratorId) {
    adminCubit.fetchAdmins(1); // Fetch admins when the dialog is opened
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: adminCubit,
          child: BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state is AdminLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColor.secondColor));
              } else if (state is AdminSuccess) {
                final admins = state.getAdmin ?? []; // Get the list of admins
                return Container(
                  height: 155,
                  width: 319,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
                  child: AlertDialog(
                    title: Text('Select Admin',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                    content: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(gapPadding: 10),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      hint: const Text('Select Admin'),
                      value: selectedClientId,
                      items: admins.map((Admin admin) {
                        return DropdownMenuItem<String>(
                          value: '${admin.id}',
                          child: Text('${admin.firstName} ${admin.lastName}'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedClientId = newValue;
                        });
                      },
                    ),
                    actions: [
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.greyColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                                child: Center(
                                    child: Text('Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(fontSize: 16, color: AppColor.thirdColor))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (selectedClientId != null) {
                                    context.read<CollaboratorCubit>().assignCollaboratorToAdmin(
                                        collaboratorId, int.parse(selectedClientId!));
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.buttonColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                                child: Text('Assign',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 16, color: AppColor.whiteColor)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (state is AdminError) {
                return Container(
                  height: 155,
                  width: 319,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
                  child: AlertDialog(
                    title: const Text('Select Admin'),
                    content: Text('Failed to load admins: ${state.errorMessage}'),
                    actions: [
                      SizedBox(
                        height: 30,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.greyColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)))),
                          child: Center(
                              child: Text('Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 16, color: AppColor.thirdColor))),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  void showAssignToClientDialog(int collaboratorId) {
    clientCubit.fetchClients(1);
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: clientCubit,
          child: BlocBuilder<ClientCubit, ClientState>(
            builder: (context, state) {
              if (state is ClientLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.secondColor),
                );
              } else if (state is ClientSuccess) {
                final clients = state.getClient ?? []; // Get the list of clients
                return Container(
                  height: 155,
                  width: 319,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
                  child: AlertDialog(
                    title: Text('Select Client',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                    content: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(gapPadding: 10),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      ),
                      hint: const Text('Select Client'),
                      value: selectedClientId,
                      items: clients.map((Client client) {
                        return DropdownMenuItem<String>(
                          value: '${client.id}',
                          child: Text('${client.firstName} ${client.lastName}'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedClientId = newValue;
                        });
                      },
                    ),
                    actions: [
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 30,
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.greyColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                                child: Center(
                                  child: Text('Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: 16, color: AppColor.thirdColor)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: SizedBox(
                              height: 30,
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (selectedClientId != null) {
                                    context.read<CollaboratorCubit>().assignCollaboratorToClient(
                                        collaboratorId, int.parse(selectedClientId!));
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.buttonColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                                child: Text('Assign',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 16, color: AppColor.whiteColor)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (state is ClientError) {
                return Container(
                  height: 155,
                  width: 319,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
                  child: AlertDialog(
                    title: const Text('Select Client'),
                    content: Text('Failed to load clients: ${state.errorMessage}'),
                    actions: [
                      SizedBox(
                        height: 30,
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.greyColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)))),
                          child: Center(
                            child: Text('Cancel',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 16, color: AppColor.thirdColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}
