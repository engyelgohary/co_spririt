import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:co_spirit/ui/sheets/cubit/sheet_state.dart';

class NewTaskCategoryCubit extends Cubit<SheetState> {
  SMDataSource smDataSource;
  NewTaskCategoryCubit({required this.smDataSource}) : super(SheetInitialState());

  Future<void> taskServiceList() async {
    emit(SheetLoadingState());
    try {
      emit(SheetSuccessfulState(await smDataSource.projectNameAndId()));
    } catch (e) {
      print("- taskServiceList error : $e");
      emit(SheetFailureState(e.toString()));
    }
  }
}
