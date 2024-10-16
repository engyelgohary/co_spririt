import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/dip.dart';
import '../../../data/model/RequestsResponse.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import '../../od/requests/cubit/requests_cubit.dart';
import '../../om/adminforsuperadmin/infoAdmin.dart';

class RequestAdmin extends StatefulWidget {
  static const String routeName = 'Request Admin';

  const RequestAdmin({super.key});

  @override
  State<RequestAdmin> createState() => _RequestAdminState();
}

class _RequestAdminState extends State<RequestAdmin> {
  late RequestsCubit viewModel;

  void initState() {
    super.initState();
    viewModel = RequestsCubit(
        requestsRepository: injectRequestsRepository(),
        typesRepository: injectTypesRepository(),
        adminRepository: injectAdminRepository(),
        collaboratorRepository: injectCollaboratorRepository());
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
        leading: const AppBarCustom(),
      ),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<RequestsCubit, RequestsState>(
          bloc: viewModel,
          builder: (context, state) {
            return PagedListView<int, RequestsResponse>.separated(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<RequestsResponse>(
                itemBuilder: (context, item, index) {
                  return ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.h),
                      child: Text(item.description ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.requestType,
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                        Text(item.type ?? "",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Respond to Request",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
                                  content: const Text(
                                      "Would you like to accept or reject this request?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Reject"),
                                      onPressed: () async {
                                        Navigator.of(context).pop(); // Close the dialog
                                        await viewModel.respondToRequest(
                                            item.id ?? 0, false); // Send rejection
                                        onOpportunityAdded(); // Refresh the list
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Accept"),
                                      onPressed: () async {
                                        Navigator.of(context).pop(); // Close the dialog
                                        await viewModel.respondToRequest(
                                            item.id ?? 0, true); // Send acceptance
                                        onOpportunityAdded(); // Refresh the list
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColor.SkyColor,
                            radius: 18,
                            child: const Icon(
                              Icons.add_task,
                              color: AppColor.secondColor,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                viewModel.fetchRequestDetails(item.id ?? 0);
                                return BlocBuilder<RequestsCubit, RequestsState>(
                                  bloc: viewModel,
                                  builder: (context, state) {
                                    if (state is RequestsSuccess) {
                                      if (state.requestData == null) {
                                        return const Center(
                                            child: CircularProgressIndicator(
                                          color: AppColor.secondColor,
                                        ));
                                      }
                                      return Container(
                                        height: 200,
                                        width: 369,
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            CustomTextInfo(
                                                fieldName: 'Title :', data: "${item.description}"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            CustomTextInfo(
                                                fieldName: 'Type :', data: "${item.requestType}"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            CustomTextInfo(
                                                fieldName: 'Status :', data: "${item.type}"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            CustomTextInfo(
                                                fieldName: 'Collaborator Name :',
                                                data: "${item.from}"),
                                          ],
                                        ),
                                      );
                                    } else if (state is RequestsError) {
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
                  );
                },
                firstPageErrorIndicatorBuilder: buildErrorIndicator,
                noItemsFoundIndicatorBuilder: (context) =>
                    const Center(child: Text("No Requests found")),
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
}
