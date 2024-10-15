import 'package:co_spirit/data/dip.dart';
import 'package:co_spirit/data/model/RequestsResponse.dart';
import 'package:co_spirit/ui/od/requests/cubit/requests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import '../../om/adminforsuperadmin/infoAdmin.dart';
import 'addRequest.dart';

class RequestCollaborator extends StatefulWidget {
  static const String routeName = 'Request Collaborator';
  const RequestCollaborator({super.key});

  @override
  State<RequestCollaborator> createState() => _RequestCollaboratorState();
}

class _RequestCollaboratorState extends State<RequestCollaborator> {
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RequestDetailDialog(
                      onOpportunityAdded: onOpportunityAdded,
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 16.r, // Adjust the radius as needed
                backgroundColor: AppColor.secondColor,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
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
                  return Slidable(
                    startActionPane: ActionPane(
                      extentRatio: .22,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          onPressed: (context) {
                            viewModel.deleteRequest(item.id ?? 0);
                          },
                          backgroundColor: AppColor.errorColor,
                          foregroundColor: AppColor.whiteColor,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
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
                              style:
                                  Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                          Text('${item.type}',
                              style:
                                  Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15)),
                        ],
                      ),
                      trailing: InkWell(
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
                                      height: 200.h,
                                      width: 369.w,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          CustomTextInfo(
                                              fieldName: 'Title :', data: "${item.description}"),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          CustomTextInfo(
                                              fieldName: 'Type :', data: "${item.requestType}"),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          CustomTextInfo(
                                              fieldName: 'Status :', data: "${item.type}"),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          CustomTextInfo(
                                              fieldName: 'Admin Name :', data: "${item.to}"),
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
                          radius: 18.r,
                          child: const Icon(
                            Icons.info_outline,
                            color: AppColor.secondColor,
                            size: 20,
                          ),
                        ),
                      ),
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
