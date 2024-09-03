import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/repository/repoContract.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import '../../../../data/model/GetAdmin.dart';
part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminRepository adminRepository;
  final PagingController<int, GetAdmin> pagingController = PagingController(firstPageKey: 1);
  AdminCubit({required this.adminRepository}) : super(AdminInitial()) {
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
  XFile? updateImage;

  void selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      emit(AdminImageSelected(pickedFile));
    }
  }
  void updateAdmin(Map<String, dynamic> adminData, XFile? image) async {
    emit(AdminLoading());
    try {
      await adminRepository.updateAdmin(adminData, image);

      // Re-fetch the admin details to ensure the UI has the latest data
      int id = int.parse(adminData['id'].toString());
      var updatedAdmin = await adminRepository.fetchAdminDetails(id);
      emit(AdminSuccess(adminData: updatedAdmin));
    } catch (e) {
      emit(AdminError(errorMessage: e.toString()));
    }
  }

  void fetchAdmins(int pageKey) async {
    emit(AdminLoading());
    try {
      print("Fetching admins for page: $pageKey");
      final admins = await adminRepository.getAllAdmins(page: pageKey);
      final isLastPage = admins.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(admins);
      } else {
        pagingController.appendPage(admins, pageKey + 1);
      }
      emit(AdminSuccess(getAdmin: admins));
    } catch (error) {
      emit(AdminError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }
  Future<void> fetchAdminDetails(int id) async {
    try {
      final adminDetails = await adminRepository.fetchAdminDetails(id);
      emit(AdminSuccess(adminData: adminDetails));
    } catch (e) {
      emit(AdminError(errorMessage: e.toString()));
    }
  }
  void register() async {
    if (!formKey.currentState!.validate()) return;

    final adminData = {
      'firstName': firstName_controller.text,
      'lastName': lastName_controller.text,
      'phone': phone_controller.text,
      'email': email_controller.text,
      'canPost': canPost.toString(),
      'password': 'AdminAdmin'
    };

    emit(AdminLoading());

    try {
      final response = await adminRepository.registerAdmin(adminData, image);
      emit(AdminSuccess(adminData: response));
    } catch (e) {
      emit(AdminError(errorMessage: e.toString()));
    }
  }
  Future<void> deleteAdmin(int id) async {
    try {
      emit(AdminLoading());
      await adminRepository.deleteAdmin(id);
      emit(AdminSuccess());
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(AdminError(errorMessage: e.toString()));
      pagingController.refresh();
    }
  }
}


