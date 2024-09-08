import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/data/repository/repoContract.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
part 'collaborator_state.dart';

class CollaboratorCubit extends Cubit<CollaboratorState> {
  final CollaboratorRepository collaboratorRepository;
  final PagingController<int, Collaborator> pagingController = PagingController(firstPageKey: 1);
  CollaboratorCubit({required this.collaboratorRepository}) : super(CollaboratorInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      fetchCollaborators(pageKey);
    });
  }
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final contractStartController = TextEditingController(text: "2024/05/09");
  final contractEndController = TextEditingController(text: "2025/05/09");
  XFile? image;
  File? cv;
  void fetchCollaborators(int pageKey) async {
    if (state is! CollaboratorLoading) {
      emit(CollaboratorLoading());
    }
    try {
      print("Fetching collaborators for page: $pageKey");
      final collaborators = await collaboratorRepository.fetchAllCollaborators(page: pageKey);
      final isLastPage = collaborators.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(collaborators);
      } else {
        pagingController.appendPage(collaborators, pageKey + 1);
      }
      emit(CollaboratorSuccess(getCollaborator: collaborators));
    } catch (error) {
      print("Error fetching collaborators: $error");
      emit(CollaboratorError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }
  Future<void> deleteCollaborator(int id) async {
    try {
      emit(CollaboratorLoading());
      await collaboratorRepository.deleteCollaborator(id);
      emit(CollaboratorSuccess());
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(CollaboratorError(errorMessage: e.toString()));
      print(e.toString());
    }
  }
  Future<void> addCollaborator() async {
    if (!formKey.currentState!.validate()) return;
final collaboratorData = {
  'FirstName': firstNameController.text,
  'LastName' : lastNameController.text,
  'Phone':phoneController.text,
  "Email":emailController.text,
  "ContractStart": contractStartController.text,
  "ContractEnd":contractEndController.text
};
    emit(CollaboratorLoading());

    try {
      final result = await collaboratorRepository.addCollaborator(collaboratorData,image,cv);
      emit(CollaboratorSuccess(collaboratorData: result));
    } catch (e) {
      emit(CollaboratorError(errorMessage:e.toString()));
   print(e.toString());
    }
  }
  void selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = pickedFile;
      emit(CollaboratorImageSelected(pickedFile));
    }
  }
  void selectCv() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      cv = File(result.files.single.path!);
      emit(CollaboratorCvSelected(cv!));
    }
  }
  Future<void> fetchCollaboratorDetails(int id) async {
    try {
      final collaboratorDetails = await collaboratorRepository.fetchCollaboratorDetails(id);
      emit(CollaboratorSuccess(collaboratorData: collaboratorDetails));
    } catch (e) {
      emit(CollaboratorError(errorMessage: e.toString()));
    }
  }
  void updateCollaborator(Map<String, dynamic> collaboratorData, XFile? image,File?cv) async {
    emit(CollaboratorLoading());
    try {
      print('Attempting to update Collaborator');
      await collaboratorRepository.updateCollaborator(collaboratorData, image, cv);

      int id = int.parse(collaboratorData['id'].toString());
      var updatedCollaborator = await collaboratorRepository.fetchCollaboratorDetails(id);

      emit(CollaboratorSuccess(collaboratorData: updatedCollaborator));
      print('Collaborator updated successfully');
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(CollaboratorError(errorMessage:e.toString()));
      print('Error updating Collaborator: $e');
    }
  }
  Future<void> assignCollaboratorToAdmin(int collaboratorId, int adminId) async {
    emit(CollaboratorLoading());
    try{
      var assignToAdmin = await collaboratorRepository.assignCollaboratorToAdmin(collaboratorId, adminId);
      emit(CollaboratorSuccess(collaboratorData:  assignToAdmin));
    }catch(e){
      emit(CollaboratorError(errorMessage:e.toString()));
      print(e.toString());
    }
  }
  Future<void> assignCollaboratorToClient(int collaboratorId, int clientId) async {
    emit(CollaboratorLoading());
    try{
      var assignToClient = await collaboratorRepository.assignCollaboratorToClient(collaboratorId, clientId);
      emit(CollaboratorSuccess(collaboratorData:  assignToClient));
    }catch(e){
      emit(CollaboratorError(errorMessage:e.toString()));
      print(e.toString());
    }
  }
}
