import 'package:co_spirit/ui/om/clientsForSuperAdmin/Cubit/client_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/dip.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class AddClientScreen extends StatefulWidget {
  final VoidCallback onOpportunityAdded;

  const AddClientScreen({super.key, required this.onOpportunityAdded});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  late ClientCubit viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = ClientCubit(clientRepository: injectClientRepository());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientCubit, ClientState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is ClientLoading) {
          const CircularProgressIndicator();
        } else if (state is ClientError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
          print(state.errorMessage);
        } else if (state is ClientSuccess) {
          widget.onOpportunityAdded(); // Call the callback
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Client Added Successfully"),
          ));
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            height: 450,
            margin: const EdgeInsets.all(20),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                      fieldName: 'First Name :',
                      width: 2,
                      controller: viewModel.firstName_controller),
                  SizedBox(height: 11),
                  CustomText(
                    fieldName: 'Last Name :',
                    controller: viewModel.lastName_controller,
                    keyboardType: TextInputType.text,
                    width: 2,
                  ),
                  SizedBox(height: 11),
                  CustomText(
                    fieldName: 'E-mail :',
                    controller: viewModel.email_controller,
                    width: 30,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 11),
                  CustomText(
                    fieldName: 'Phone :',
                    controller: viewModel.phone_controller,
                    width: 32,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 35,
                        width: 135,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Center(
                              child: Text('Cancel',
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontSize: 16,
                                      color: AppColor.thirdColor,
                                      fontWeight: FontWeight.w400))),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.greyColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)))),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        width: 135,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.addClient();
                          },
                          child: Center(
                              child: Text('Add',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 16, color: AppColor.whiteColor))),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
