import 'package:co_spirit/data/model/Client.dart';
import 'package:co_spirit/ui/om/clientsForSuperAdmin/Cubit/client_cubit.dart';
import 'package:co_spirit/ui/om/clientsForSuperAdmin/add_client.dart';
import 'package:co_spirit/ui/om/clientsForSuperAdmin/infoClient.dart';
import 'package:co_spirit/ui/om/clientsForSuperAdmin/updateClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/dip.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import '../collaboratorforsuperadmin/Cubit/collaborator_cubit.dart';

class ClientScreenfoSuper extends StatefulWidget {
  const ClientScreenfoSuper({super.key});

  @override
  State<ClientScreenfoSuper> createState() => _ClientScreenfoSuperState();
}

class _ClientScreenfoSuperState extends State<ClientScreenfoSuper> {
  late ClientCubit viewModel;
  late CollaboratorCubit collaboratorCubit;

  @override
  void initState() {
    super.initState();
    viewModel = ClientCubit(clientRepository: injectClientRepository());
    collaboratorCubit = CollaboratorCubit(collaboratorRepository: injectCollaboratorRepository());
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
          'Clients',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 25,
              backgroundColor: AppColor.secondColor,
              child:
                  const Icon(Icons.person_add_alt_outlined, color: AppColor.whiteColor, size: 20),
            ),
            onPressed: () {
              showAddBottomSheet();
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<ClientCubit, ClientState>(
          bloc: viewModel,
          builder: (context, state) {
            return PagedListView<int, Client>.separated(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<Client>(
                itemBuilder: (context, item, index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      extentRatio: .22,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          onPressed: (context) {
                            viewModel.deleteClient(item.id ?? 1);
                          },
                          backgroundColor: AppColor.errorColor,
                          foregroundColor: AppColor.whiteColor,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
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
                              showUpdateClientDialog(item);
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
                          SizedBox(width: 16.w),
                          InkWell(
                            onTap: () {
                              showClientDetailsBottomSheet(item.id ?? 1);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18,
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
                noItemsFoundIndicatorBuilder: (context) =>
                    const Center(child: Text("No Clients found")),
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

  void showClientDetailsBottomSheet(int id) {
    viewModel.fetchClientDetails(id);
    collaboratorCubit.fetchCollaborators(1);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: viewModel),
            BlocProvider.value(value: collaboratorCubit),
          ],
          child: BlocBuilder<ClientCubit, ClientState>(
            bloc: viewModel,
            builder: (context, clientstate) {
              return BlocBuilder(
                bloc: collaboratorCubit,
                builder: (context, collaboratorState) {
                  if (collaboratorState is CollaboratorSuccess && clientstate is ClientSuccess) {
                    return InfoClient(
                      client: clientstate.clientData,
                      collaborator: collaboratorState.getCollaborator ?? [],
                    );
                  } else if (clientstate is ClientError) {
                    return Center(child: Text(clientstate.errorMessage ?? ""));
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

  void showUpdateClientDialog(Client client) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider.value(value: viewModel, child: UpdateClient(client: client));
      },
    );
  }

  void showAddBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => ClientCubit(clientRepository: injectClientRepository()),
          child: AddClientScreen(
            onOpportunityAdded: onOpportunityAdded,
          ),
        );
      },
    );
  }
}
