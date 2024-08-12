import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/model/Type.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import '../../../../data/repository/repoContract.dart';
part 'types_state.dart';

class TypesCubit extends Cubit<TypesState> {
  TypesRepository typesRepository;
  final PagingController<int, Types> pagingController =
  PagingController(firstPageKey: 1);
  TypesCubit({required this.typesRepository}) : super(TypesInitial()){
    pagingController.addPageRequestListener((pageKey) {
      fetchTypes(pageKey);
    });
  }
  TextEditingController Type_controller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Future<void> fetchTypes(int pageKey) async {
    emit(TypesLoading());
    try {
      final types = await typesRepository.fetchAllTypes(page: pageKey);
      final isLastPage = types.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(types);
      } else {
        pagingController.appendPage(types, pageKey + 1);
      }
      emit(TypesSuccess(getType: types));
    } catch (error) {
      emit(TypesError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }
  Future<void> addType() async {
    if (!formKey.currentState!.validate()) return;
    emit(TypesLoading());
    try {
      final response = await typesRepository.addType(Type_controller.text);
      emit(TypesSuccess(typeData:response));
    } catch (e) {
      emit(TypesError(errorMessage: e.toString()));
      print(e.toString());
    }
  }
  Future<void> deleteType(int id) async {
    try {
      emit(TypesLoading());
      await typesRepository.deleteTypes(id);
      emit(TypesSuccess());
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(TypesError(errorMessage: e.toString()));
    }
  }
  Future<void> fetchTypeDetails(int id) async {
    try {
      final typeDetails = await typesRepository.fetchTypeDetails(id);
      emit(TypesSuccess(typeData: typeDetails));
    } catch (e) {
      emit(TypesError(errorMessage: e.toString()));
    }
  }
  Future<void> updateType(int id, String type) async {
    try {
      emit(TypesLoading());
      await typesRepository.updateTypes(
          id, type);
      emit(TypesSuccess());
      pagingController.refresh();
    } catch (e) {
      emit(TypesError(errorMessage: e.toString()));
    }
  }
}
