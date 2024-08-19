import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../data/dip.dart';
import '../../../data/model/RequestsResponse.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';
import '../../collaborator/requests/cubit/requests_cubit.dart';
import '../../superadmin/adminforsuperadmin/infoAdmin.dart';

class RequestAdmin extends StatefulWidget {
  static const String routeName = 'Request Admin';

   RequestAdmin({super.key});

  @override
  State<RequestAdmin> createState() => _RequestAdminState();
}

class _RequestAdminState extends State<RequestAdmin> {
  final List<String> requests = List.generate(10, (index) => 'Title1');

  late RequestsCubit viewModel;

  void initState() {
    super.initState();
    viewModel = RequestsCubit(requestsRepository: injectRequestsRepository(),typesRepository: injectTypesRepository(),adminRepository: injectAdminRepository(),collaboratorRepository: injectCollaboratorRepository());
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
        leading: AppBarCustom(),
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
                        padding:  EdgeInsets.symmetric(vertical: 0.h),
                        child: Text(item.description ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 18,fontWeight: FontWeight.w700)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.requestType, style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 15)),
                          Text('${item.statusType}', style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 15)),
                        ],
                      ),
                      trailing:InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              viewModel.fetchRequestDetails(item.id??0);
                              return BlocBuilder<RequestsCubit, RequestsState>(
                                bloc: viewModel,
                                builder: (context, state) {
                                  if (state is RequestsSuccess) {
                                    if (state.requestData == null) {
                                      return Center(
                                          child: CircularProgressIndicator(
                                            color: AppColor.secondColor,
                                          )); }
                                    return Container(
                                      height: 200.h,
                                      width: 369.w,
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          CustomTextInfo(fieldName:'Title :' ,data:"${item.description}"),
                                          SizedBox(height: 5.h,),
                                          CustomTextInfo(fieldName:'Type :' ,data:"${item.requestType}"),
                                          SizedBox(height: 5.h,),
                                          CustomTextInfo(fieldName:'Status :' ,data:"${item.statusType}"),
                                          SizedBox(height: 5.h,),
                                          CustomTextInfo(fieldName:'Admin Name :' ,data:"${item.to}"),

                                        ],
                                      ),
                                    );
                                  } else if (state is RequestsError) {
                                    return Center(child: Text(state.errorMessage??""));
                                  } else {
                                    return Center(child: CircularProgressIndicator(
                                      color: AppColor.secondColor,
                                    ));
                                  }
                                },
                              );
                            },
                          );                        },
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
                  );
                },
                firstPageErrorIndicatorBuilder: buildErrorIndicator,
                noItemsFoundIndicatorBuilder: (context) =>
                    Center(child: Text("No Requests found")),
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



class RequestDetailDialog extends StatefulWidget {
  @override
  _RequestDetailDialogState createState() => _RequestDetailDialogState();
}

class _RequestDetailDialogState extends State<RequestDetailDialog> {
  String? selectedStatus;
  List<String> statusOptions = ['Status 1', 'Status 2', 'Status 3'];
  TextEditingController titleController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 319.w,
      height: 254.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r)
      ),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Request Title : ', style: Theme.of(context).textTheme.titleMedium),
                Expanded(
                  child: Text('Title'),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text('Request Type : ', style: Theme.of(context).textTheme.titleMedium),
                Expanded(
                  child: Text('Type'
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            Text('Request Status', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.h),
            Container(
              height:32.h ,
              width: 300.w,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Adjust padding as needed
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor, width: 1.w),
                    borderRadius: BorderRadius.circular(5.r)// Border color and width can be customized
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor, width: 1.w),
                      borderRadius: BorderRadius.circular(5.r)
                  ),
                ),
                value: selectedStatus,
                hint: Text("Status 1",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12,color: AppColor.blackColor),),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                },
                items: statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12,color: AppColor.blackColor),),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height:35.h,
                width: 120.w,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Center(child: Text('Reject',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.thirdColor))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.greyColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.r)))),
                ),
              ),
              SizedBox(width: 5.w,),
              Container(
                height:35.h,
                width: 120.w,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Center(child: Text('Accept',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.whiteColor))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.r)))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

