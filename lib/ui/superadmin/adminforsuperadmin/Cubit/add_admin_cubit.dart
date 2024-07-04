import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/model/AdminUser.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../../../../../data/repository/repoContract.dart';
import '../../../../data/model/GetAdmin.dart';
part 'add_admin_state.dart';

class AddAdminCubit extends Cubit<AddAdminState> {
  AuthRepository authRepository;
  final PagingController<int, GetAdmin> pagingController = PagingController(firstPageKey: 1);
  AddAdminCubit({required this.authRepository}) : super(AddAdminInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      fetchAdmins(pageKey);
    });
  }
  bool canPost = true;
  TextEditingController firstName_controller = TextEditingController();
  TextEditingController lastName_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void register() async {
    if (formKey.currentState!.validate() == true) {
      try {
        emit(AddAdminLoading());
        var response = await authRepository.registerAdmin(
            firstName: firstName_controller.text,
            email: email_controller.text,
            password: password_controller.text,
            lastName: lastName_controller.text,
            phone: phone_controller.text);
        if (response.status! >= 200 && response.status! < 300) {
          emit(AddAdminSuccess(adminUser: response));
          return;
        }
        else {
          emit(AddAdminError(errorMessage: response.title));
          print(response.errors!.password);
          print(response.errors!.email);
          print(response.errors!.phone);


          return;
        }
      } catch (e) {
        emit(AddAdminError(errorMessage: "$e"));
      }
    }
  }

  void fetchAdmins(int pageKey) async {
    emit(AddAdminLoading());
    try {
      print("Fetching admins for page: $pageKey");
      final admins = await authRepository.getAllAdmins(page: pageKey);
      final isLastPage = admins.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(admins);
      } else {
        pagingController.appendPage(admins, pageKey + 1);
      }
      emit(AddAdminSuccess(getAdmin: admins));
    } catch (error) {
      emit(AddAdminError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }
}


