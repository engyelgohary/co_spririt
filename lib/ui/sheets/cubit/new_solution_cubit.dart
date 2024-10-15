import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:co_spirit/ui/sheets/cubit/sheet_state.dart';

class NewSolutionCubit extends Cubit<SheetState> {
  SMDataSource smDataSource;
  NewSolutionCubit({required this.smDataSource}) : super(SheetInitialState());

  Future<void> taskServiceList() async {
    emit(SheetLoadingState());
    try {
      final targets = await smDataSource.getTargetService();
      Map output = {};
      for (var target in targets) {
        output.addAll({target["name"]: target["id"]});
      }
      emit(SheetSuccessfulState(output));
    } catch (e) {
      print("- taskCategoryList error : $e");
      emit(SheetFailureState(e.toString()));
    }
  }
}
