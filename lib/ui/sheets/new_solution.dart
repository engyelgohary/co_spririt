import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/sheets/cubit/new_solution_cubit.dart';
import 'package:co_spirit/ui/sheets/cubit/sheet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewSolution extends StatefulWidget {
  const NewSolution({super.key});

  @override
  State<NewSolution> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewSolution> {
  ApiManager apiManager = ApiManager.getInstance();
  final TextEditingController solution = TextEditingController();
  final TextEditingController customerValue = TextEditingController();
  final TextEditingController targetCustomer = TextEditingController();
  final TextEditingController customer = TextEditingController();
  final TextEditingController phase = TextEditingController();
  final TextEditingController stakeholder = TextEditingController();
  final TextEditingController rd = TextEditingController();
  final TextEditingController targetService = TextEditingController();
  final GlobalKey formKey = GlobalKey();
  final NewSolutionCubit newSolutionCubit = NewSolutionCubit(
    smDataSource: SMDataSourceRemote(apiManager: ApiManager.getInstance()),
  );
  Map targetServices = {};

  @override
  void initState() {
    newSolutionCubit.taskServiceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          return BlocBuilder<NewSolutionCubit, SheetState>(
            bloc: newSolutionCubit,
            builder: (context, state) {
              if (state is SheetLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SheetSuccessfulState) {
                targetServices = state.response;
                return SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OpportunityTextFormField(
                          fieldName: 'Solution',
                          controller: solution,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter solution';
                            }
                            return null;
                          },
                        ),
                        OpportunityDropDownMenu(
                          fieldName: 'Target Service',
                          controller: targetService,
                          selection: targetService,
                          dropDownOptions: targetServices.keys.toList(),
                          textColor: ODColorScheme.mainColor,
                        ),
                        OpportunityTextFormField(
                          fieldName: 'Customer value',
                          controller: customerValue,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter customer value';
                            }
                            return null;
                          },
                          maxLines: null,
                          minLines: 3,
                        ),
                        OpportunityTextFormField(
                          fieldName: "Target Customer/Users:",
                          controller: targetCustomer,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter target customer/users';
                            }
                            return null;
                          },
                        ),
                        OpportunityTextFormField(
                          fieldName: "Co-working Customer:",
                          controller: customer,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter co-working customer';
                            }
                            return null;
                          },
                        ),
                        OpportunityTextFormField(
                          fieldName: "Phase:",
                          controller: phase,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter phase';
                            }
                            return null;
                          },
                        ),
                        OpportunityTextFormField(
                          fieldName: "Co-working Stakeholder",
                          controller: stakeholder,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter co-working stakeholder';
                            }
                            return null;
                          },
                        ),
                        OpportunityTextFormField(
                          fieldName: "Target Co-R&D",
                          controller: rd,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter target Co-R&D';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 15, vertical: 32),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: ODColorScheme.disabledColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                            fontSize: 16,
                                            color: AppColor.whiteColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (solution.text.isEmpty ||
                                        customerValue.text.isEmpty ||
                                        targetCustomer.text.isEmpty ||
                                        customer.text.isEmpty ||
                                        targetService.text.isEmpty ||
                                        phase.text.isEmpty ||
                                        stakeholder.text.isEmpty ||
                                        rd.text.isEmpty) {
                                      return;
                                    }
                                    loadingIndicatorDialog(context);
                                    try {
                                      await apiManager.AddSolution(
                                        targetServiceId: targetServices[targetService.text],
                                        solution: solution.text,
                                        customerValue: customerValue.text,
                                        targetCustomerUser: targetCustomer.text,
                                        coWorkingCustomer: customer.text,
                                        phase: phase.text,
                                        coWorkingStakeHolder: stakeholder.text,
                                        targetCoRD: rd.text,
                                      );
                                      snackBar(context, "Done");
                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      snackBar(context, "Error $e");
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: ODColorScheme.buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Submit',
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                            fontSize: 16,
                                            color: AppColor.whiteColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: buildErrorIndicator(
                  "Some error occurred, Please try again.",
                  () => newSolutionCubit.taskServiceList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
