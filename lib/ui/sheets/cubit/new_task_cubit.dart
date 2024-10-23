import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:co_spirit/ui/sheets/cubit/sheet_state.dart';

class NewTaskCubit extends Cubit<SheetState> {
  SMDataSource smDataSource;
  NewTaskCubit({required this.smDataSource}) : super(SheetInitialState());

  Future<void> taskServiceList() async {
    emit(SheetLoadingState());
    try {
      final projectsMap = {};
      final projectsSubTaskMap = {};
      final projectsTaskMap = {};
      final teamsMap = {};
      final statusMap = {};

      final projects = await smDataSource.projectNameAndId();
      final teams = await smDataSource.memberNameAndId();
      final status = await smDataSource.taskStatusNameAndId();

      for (var team in teams) {
        teamsMap.addAll({team["name"]: team["id"]});
      }

      for (var _status in status) {
        statusMap.addAll({_status["name"]: _status["id"]});
      }

      for (var project in projects) {
        projectsMap.addAll({project["name"]: project["id"]});

        final temp = {};
        final category = await smDataSource.categoryNameAndId(projectId: project["id"]);

        for (var _category in category) {
          temp.addAll({_category["name"]: _category["id"]});

          final tempTask = {};
          final tasks = await smDataSource.taskNameAndId(categoryId: _category["id"]);

          for (var task in tasks) {
            tempTask.addAll({task["name"]: task["id"]});
          }

          projectsTaskMap.addAll({_category["name"]: tempTask});
        }

        projectsSubTaskMap.addAll({project["name"]: temp});
      }
      print(statusMap);
      emit(SheetSuccessfulState(
          [projectsMap, projectsSubTaskMap, projectsTaskMap, teamsMap, statusMap]));
    } catch (e) {
      print("- taskCategoryList error : $e");
      emit(SheetFailureState(e.toString()));
    }
  }
}
