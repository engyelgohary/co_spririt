import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:flutter/material.dart';

part 'new_solution_state.dart';

class NewSolutionCubit extends Cubit<NewSolutionState> {
  SMDataSource smDataSource;
  NewSolutionCubit({required this.smDataSource}) : super(NewSolutionInitialState());

  Future<void> taskServiceList() async {
    emit(NewSolutionLoadingState());
    try {
      final targets = await smDataSource.getTargetService();
      Map output = {};
      for (var target in targets) {
        output.addAll({target["name"]: target["id"]});
      }
      emit(NewSolutionSuccessfulState(output));
    } catch (e) {
      print("- taskCategoryList error : $e");
      emit(NewSolutionFailureState(e.toString()));
    }
  }
}
