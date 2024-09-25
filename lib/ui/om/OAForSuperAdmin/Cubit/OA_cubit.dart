import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:co_spirit/data/model/OA.dart';
import '../../../../data/repository/repoContract.dart';

part 'OA_state.dart';

class OpportunityAnalyzerCubit extends Cubit<OpportunityAnalyzerState> {
  OpportunityAnalyzerRepository opportunityAnalyzerRepository;
  final PagingController<int, OA> pagingController = PagingController(firstPageKey: 1);

  OpportunityAnalyzerCubit({required this.opportunityAnalyzerRepository})
      : super(OpportunityAnalyzerInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      getAllOAs(pageKey);
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
      emit(OpportunityAnalyzerImageSelected(pickedFile));
    }
  }

  // Fetch all Opportunity Analyzers
  void getAllOAs(int pageKey) async {
    emit(OpportunityAnalyzerLoading());
    try {
      print("Fetching OAs for page: $pageKey");
      final oas = await opportunityAnalyzerRepository.getAllOAs(page: pageKey);
      final isLastPage = oas.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(oas);
      } else {
        pagingController.appendPage(oas, pageKey + 1);
      }
      emit(OpportunityAnalyzerSuccess(getOAs: oas));
    } catch (error) {
      emit(OpportunityAnalyzerError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }

  Future<void> fetchOADetails(String id) async {
    emit(OpportunityAnalyzerLoading());
    try {
      print("Fetching OA details for ID: $id");
      final oaDetails = await opportunityAnalyzerRepository.fetchOADetails(id);
      print("Fetched details: ${oaDetails.toString()}");
      emit(OpportunityAnalyzerDetailsSuccess(opportunityAnalyzerData: oaDetails));
    } catch (error) {
      print("Error fetching details: $error");
      emit(OpportunityAnalyzerError(errorMessage: error.toString()));
    }
  }

  void addOA() async {
    if (!formKey.currentState!.validate()) return;

    final opportunityAnalyzerData = {
      'firstName': firstName_controller.text,
      'lastName': lastName_controller.text,
      'phone': phone_controller.text,
      'email': email_controller.text,
      'canPost': canPost.toString(),
      'password': 'AdminAdmin'
    };

    emit(OpportunityAnalyzerLoading());

    try {
      final response = await opportunityAnalyzerRepository.addOA(opportunityAnalyzerData, image);

      emit(OpportunityAnalyzerSuccess(opportunityAnalyzerData: response));
    } catch (e) {
      emit(OpportunityAnalyzerError(errorMessage: e.toString()));
    }
  }
}
