import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:flutter/material.dart';

part 'raci_state.dart';

class RACICubit extends Cubit<RACIState> {
  SMDataSource smDataSource;
  RACICubit({required this.smDataSource}) : super(RACIInitialState());

  Future<void> getRACI() async {
    emit(RACILoadingState());
    try {
      List projectsList = [];
      Map categoriesMap = {};
      Map tasksMap = {};

      final projects = await smDataSource.projectNameAndId();

      for (var project in projects) {
        projectsList.add(project["name"]);

        List temp = [];
        final categories = await smDataSource.categoryNameAndId(projectId: project["id"]);

        for (var category in categories) {
          temp.add(category["name"]);
        }

        categoriesMap.addAll({project["name"]: temp});
      }

      final tasks = await smDataSource.getTasks();

      for (var task in tasks) {
        if (!tasksMap.containsKey("${task["projectName"]}-${task["category"]}")) {
          tasksMap["${task["projectName"]}-${task["category"]}"] = [];
        }
        tasksMap["${task["projectName"]}-${task["category"]}"].add(task);
      }

      emit(RACISuccessfulState([projectsList, categoriesMap, tasksMap]));
    } catch (e) {
      print("- taskCategoryList error : $e");
      emit(RACIFailureState(e.toString()));
    }
  }
}
