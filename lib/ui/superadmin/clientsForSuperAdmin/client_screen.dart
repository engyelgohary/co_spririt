import 'package:co_spririt/data/model/Client.dart';
import 'package:co_spririt/ui/superadmin/clientsForSuperAdmin/Cubit/client_cubit.dart';
import 'package:co_spririt/ui/superadmin/clientsForSuperAdmin/add_client.dart';
import 'package:co_spririt/ui/superadmin/clientsForSuperAdmin/infoClient.dart';
import 'package:co_spririt/ui/superadmin/clientsForSuperAdmin/updateClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/dip.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';

class ClientScreenfoSuper extends StatefulWidget {
  const ClientScreenfoSuper({super.key});

  @override
  State<ClientScreenfoSuper> createState() => _ClientScreenfoSuperState();
}

class _ClientScreenfoSuperState extends State<ClientScreenfoSuper> {
  late ClientCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ClientCubit(clientRepository: injectClientRepository());
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
          'Clients',
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
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12),
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
                              showClientDetailsBottomSheet(item.id ?? 1);
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColor.SkyColor,
                              radius: 18.r,
                              child: Icon(
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
    );
  }

  void showClientDetailsBottomSheet(int id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        viewModel.fetchClientDetails(id);
        return BlocBuilder<ClientCubit, ClientState>(
          bloc: viewModel,
          builder: (context, state) {
            if (state is ClientSuccess) {
              return InfoClient(
                client: state.clientData,
              );
            } else if (state is ClientError) {
              return Center(child: Text(state.errorMessage ?? ""));
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: AppColor.secondColor,
              ));
            }
          },
        );
      },
    );
  }

  void showUpdateClientDialog(Client client) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider.value(
            value: viewModel, child: UpdateClient(client: client));
      },
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
            heightFactor: .6,
            child: AddClientScreen(),
          ),
        );
      },
    );
  }
}
