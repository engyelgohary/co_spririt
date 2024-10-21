import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:co_spirit/data/model/OW.dart'; // Assuming you have an OW model
part 'ow_state.dart';

class OpportunityOwnerCubit extends Cubit<OpportunityOwnerState> {
  final OpportunityOwnerRepositoryRemote opportunityOwnerRepository;
  final PagingController<int, OW> pagingController = PagingController(firstPageKey: 1);

  OpportunityOwnerCubit({required this.opportunityOwnerRepository})
      : super(OpportunityOwnerInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      getAllOWs(pageKey);
    });
  }

  bool canPost = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  XFile? image;
  XFile? updateImage;

  void selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      emit(OpportunityOwnerImageSelected(pickedFile));
    }
  }

  void getAllOWs(int pageKey) async {
    emit(OpportunityOwnerLoading());
    try {
      print("Fetching OWs for page: $pageKey");
      final ows = await opportunityOwnerRepository.getAllOWs(page: pageKey);
      final isLastPage = ows.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(ows);
      } else {
        pagingController.appendPage(ows, pageKey + 1);
      }
      emit(OpportunityOwnerSuccess(getOWs: ows));
    } catch (error) {
      emit(OpportunityOwnerError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }

  Future<void> fetchOWDetails(String id) async {
    emit(OpportunityOwnerLoading());
    try {
      print("Fetching OW details for ID: $id");
      final owDetails = await opportunityOwnerRepository.fetchOWDetails(id);
      print("Fetched details: ${owDetails.toString()}");
      emit(OpportunityOwnerDetailsSuccess(opportunityOwnerData: owDetails));
    } catch (error) {
      print("Error fetching details: $error");
      emit(OpportunityOwnerError(errorMessage: error.toString()));
    }
  }

  void addOW() async {
    if (!formKey.currentState!.validate()) return;

    final opportunityOwnerData = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'canPost': canPost.toString(),
      'password': 'AdminAdmin'
    };

    emit(OpportunityOwnerLoading());

    try {
      final response = await opportunityOwnerRepository.addOW(opportunityOwnerData, image);
      emit(OpportunityOwnerSuccess(opportunityOwnerData: response));
    } catch (e) {
      emit(OpportunityOwnerError(errorMessage: e.toString()));
    }
  }

  Future<void> updateOW(Map<String, dynamic> OW, XFile? image) async {
    emit(OpportunityOwnerLoading());
    try {
      print("Updating OW details for ID: ${OW["id"]}");
      final oaDetails = await opportunityOwnerRepository.updateOW(OW, image);
      print("Updated details: ${oaDetails.toString()}");
      emit(OpportunityOwnerDetailsSuccess(opportunityOwnerData: oaDetails));
    } catch (error) {
      print("Error fetching details: $error");
      emit(OpportunityOwnerError(errorMessage: error.toString()));
    }
    fetchOWDetails(OW["id"]);
  }
}
