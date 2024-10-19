import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spirit/ui/om/OWForSuperAdmin/Cubit/OW_cubit.dart';
import 'package:co_spirit/ui/om/OWForSuperAdmin/addDialog.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../utils/theme/appColors.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/OW.dart';
import '../../../data/repository/repository/repository_impl.dart';
import 'info_ow.dart';

class OpportunityOwnersScreen extends StatefulWidget {
  const OpportunityOwnersScreen({super.key});

  @override
  State<OpportunityOwnersScreen> createState() => _OpportunityOwnersScreenState();
}

class _OpportunityOwnersScreenState extends State<OpportunityOwnersScreen> {
  late OpportunityOwnerCubit viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = OpportunityOwnerCubit(
      opportunityOwnerRepository: OpportunityOwnerRepositoryImpl(
        apiManager: ApiManager.getInstance(),
      ),
    );
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
        title: "Opportunity Owners",
        context: context,
        textColor: OMColorScheme.buttonColor,
        backArrowColor: OMColorScheme.mainColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.person_add_alt_outlined, color: OMColorScheme.buttonColor),
              onPressed: () {
                showAddBottomSheet();
              },
            ),
          ),
        ],
      ),
      // AppBar(
      //   title: Text(
      //     'Opportunity Owners',
      //     style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
      //   ),
      //   leading: const AppBarCustom(),
      //   actions: [
      //     IconButton(
      //       icon: CircleAvatar(
      //         radius: 25,
      //         backgroundColor: AppColor.secondColor,
      //         child: const Icon(Icons.person_add_alt_outlined, color: AppColor.whiteColor, size: 20),
      //       ),
      //       onPressed: () {
      //         showAddBottomSheet();
      //       },
      //     ),
      //   ],
      // ),
      body: BlocProvider(
        create: (context) => viewModel,
        child: BlocBuilder<OpportunityOwnerCubit, OpportunityOwnerState>(
          bloc: viewModel,
          builder: (context, state) {
            return PagedListView<int, OW>.separated(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<OW>(
                itemBuilder: (context, item, index) {
                  final owImage = 'http://${ApiConstants.baseUrl}${item.pictureLocation}';
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: owImage,
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: AppColor.secondColor,
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: AppColor.SkyColor,
                        radius: 20,
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
                      item.email ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        showOWDetailsBottomSheet(item.id.toString());
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
                  );
                },
                firstPageErrorIndicatorBuilder: buildErrorIndicator,
                noItemsFoundIndicatorBuilder: (context) =>
                    const Center(child: Text("No Owners found")),
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
        return BlocProvider.value(
          value: viewModel,
          child: AddOW(
            onOpportunityAdded: onOpportunityAdded,
          ),
        );
      },
    );
  }

  void showOWDetailsBottomSheet(String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        viewModel.fetchOWDetails(id);

        return BlocBuilder<OpportunityOwnerCubit, OpportunityOwnerState>(
          bloc: viewModel,
          builder: (context, state) {
            if (state is OpportunityOwnerLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.secondColor,
                ),
              );
            } else if (state is OpportunityOwnerDetailsSuccess) {
              return InfoOW(state.opportunityOwnerData);
            } else if (state is OpportunityOwnerError) {
              return Center(child: Text(state.errorMessage ?? "Error fetching details"));
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.secondColor,
                ),
              );
            }
          },
        );
      },
    );
  }
}
