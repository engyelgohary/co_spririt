import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/model/Type.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import '../../../../data/repository/repoContract.dart';
part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  TypesRepository typesRepository;
  final PagingController<int, Types> pagingController =
  PagingController(firstPageKey: 1);
  RequestsCubit({required this.typesRepository}) : super(RequestsInitial()){
    pagingController.addPageRequestListener((pageKey) {
      fetchTypes(pageKey);
    });
  }
  TextEditingController Type_controller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Future<void> fetchTypes(int pageKey) async {
    emit(RequestsLoading());
    try {
      final types = await typesRepository.fetchAllTypes(page: pageKey);
      final isLastPage = types.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(types);
      } else {
        pagingController.appendPage(types, pageKey + 1);
      }
      emit(RequestsSuccess(getType: types));
    } catch (error) {
      emit(RequestsError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }
  Future<void> addType() async {
    if (!formKey.currentState!.validate()) return;
    emit(RequestsLoading());
    try {
      final response = await typesRepository.addType(Type_controller.text);
      emit(RequestsSuccess(typeData:response));
    } catch (e) {
      emit(RequestsError(errorMessage: e.toString()));
      print(e.toString());
    }
  }
  Future<void> deleteType(int id) async {
    try {
      emit(RequestsLoading());
      await typesRepository.deleteTypes(id);
      emit(RequestsSuccess());
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(RequestsError(errorMessage: e.toString()));
    }
  }
  Future<void> fetchTypeDetails(int id) async {
    try {
      final typeDetails = await typesRepository.fetchTypeDetails(id);
      emit(RequestsSuccess(typeData: typeDetails));
    } catch (e) {
      emit(RequestsError(errorMessage: e.toString()));
    }
  }
  Future<void> updateType(int id, String type) async {
    try {
      emit(RequestsLoading());
      await typesRepository.updateTypes(
          id, type);
      emit(RequestsSuccess());
      pagingController.refresh();
    } catch (e) {
      emit(RequestsError(errorMessage: e.toString()));
    }
  }
}
