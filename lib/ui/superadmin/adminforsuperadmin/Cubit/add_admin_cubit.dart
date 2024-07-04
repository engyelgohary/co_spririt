import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  var formKey = GlobalKey<FormState>();
  XFile? image;

  void register() async {
    if (!formKey.currentState!.validate()) return;

    final adminData = {
      'firstName': firstName_controller.text,
      'lastName': lastName_controller.text,
      'phone': phone_controller.text,
      'email': email_controller.text,
      'canPost': canPost.toString(),
      'password':'AdminAdmin'
    };

    emit(AddAdminLoading());

    try {
      final response = await authRepository.registerAdmin(adminData, image);
      emit(AddAdminSuccess(adminData: response));
    } catch (e) {
      emit(AddAdminError(errorMessage: e.toString()));
    }
  }

  void selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      emit(AddAdminImageSelected(pickedFile));
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


