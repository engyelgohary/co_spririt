import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/model/RequestsResponse.dart';
import 'package:co_spririt/data/model/Type.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import '../../../../data/repository/repoContract.dart';
part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsRepository requestsRepository;
  TypesRepository typesRepository;
  AdminRepository adminRepository;
  CollaboratorRepository collaboratorRepository;
  final PagingController<int, RequestsResponse> pagingController =
  PagingController(firstPageKey: 1);
  RequestsCubit({required this.requestsRepository,required this.typesRepository,required this.adminRepository,required this.collaboratorRepository}) : super(RequestsInitial()){
    pagingController.addPageRequestListener((pageKey) {
      fetchRequests(pageKey);
    });
  }
  TextEditingController title_controller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  int? selectedTypeId;
  Future<void> fetchRequests(int pageKey) async {
    emit(RequestsLoading());
    try {
      final requests = await requestsRepository.fetchAllRequests(page: pageKey);
      final types = await typesRepository.fetchAllTypes(page: 1);
      final admins = await adminRepository.getAllAdmins(page: 1);
      final collaborators = await collaboratorRepository.fetchAllCollaborators(page: 1);
      final requestWithTypes = requests.map((request){
        final admin = admins.firstWhere(
            (admin) => admin.id == request.toId
        );
        final collaborator = collaborators.firstWhere(
            (collaborator) => collaborator.id == request.fromId
        );
        final type = types.firstWhere(
            (type) => type.id == request.requestTypeId,
          orElse: () => Types(id: 0,type: ""),
        );
        return RequestsResponse(
          id: request.id,
          description: request.description,
          requestType: type.type,
          to: admin.firstName,
          from: collaborator.firstName
        );
      }).toList();
      final isLastPage = requestWithTypes.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(requestWithTypes);
      } else {
        pagingController.appendPage(requestWithTypes, pageKey + 1);
      }
      emit(RequestsSuccess(getRequest: requestWithTypes));
    } catch (error) {
      emit(RequestsError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }
  Future<void> deleteRequest(int id) async {
    try {
      emit(RequestsLoading());
      await requestsRepository.deleteRequests(id);
      emit(RequestsSuccess());
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(RequestsError(errorMessage: e.toString()));
      print(e.toString());
    }
  }
  Future<void> addRequest() async {
    if (!formKey.currentState!.validate()) return;
    emit(RequestsLoading());
    try {
      final response = await requestsRepository.addRequest(title_controller.text,selectedTypeId ?? 2);
      emit(RequestsSuccess(requestData:response));
    } catch (e) {
      emit(RequestsError(errorMessage: e.toString()));
      print(e.toString());
    }
  }
  Future<void> fetchRequestDetails(int id) async {
    try {
      final requestDetails = await requestsRepository.fetchRequestDetails(id);
      emit(RequestsSuccess(requestData: requestDetails));
    } catch (e) {
      emit(RequestsError(errorMessage: e.toString()));
    }
  }
  Future<void> respondToRequest(int requestId, bool response) async{
    try{
      await requestsRepository.respondToRequest(requestId, response);
      emit(RequestsSuccess());
    }catch(e){
      emit(RequestsError(errorMessage: e.toString()));
    }
  }
}
