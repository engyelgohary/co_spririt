import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:flutter/material.dart';

part 'project_overview_state.dart';

class SolutionCubit extends Cubit<SolutionsState> {
  SMDataSource smDataSource;
  SolutionCubit({required this.smDataSource}) : super(SolutionsInitialState());

  Future<void> getSolutions() async {
    emit(SolutionsLoadingState());
    try {
      final targets = await smDataSource.getTargetService();
      Map output = {};
      for (var target in targets) {
        if (!output.containsKey(target["name"])) {
          output[target["name"]] = {};
        }

        final solutions = await smDataSource.getSolutions(id: target["id"]);
        for (var solution in solutions) {
          output[target["name"]].addAll({solution["solution"]: solution});
        }
      }
      print(output);
      emit(SolutionsSuccessfulState(output));
    } catch (e) {
      print("- solutionsList error : $e");
      emit(SolutionsFailureState(e.toString()));
    }
  }
}
