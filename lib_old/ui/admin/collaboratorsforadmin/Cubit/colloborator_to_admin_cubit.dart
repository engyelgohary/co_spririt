import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import 'package:co_spirit/data/repository/repoContract.dart';
part 'colloborator_to_admin_state.dart';

class CollaboratorToAdminCubit extends Cubit<CollaboratorToAdminState> {
  AdminRepository adminRepository;
  final PagingController<int, Collaborator> pagingController = PagingController(firstPageKey: 1);
  CollaboratorToAdminCubit({required this.adminRepository}) : super(CollaboratorToAdminInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      fetchCollaboratorData(pageKey);
    });
  }
  Future<void> fetchCollaboratorData(int page) async {
    try {
      emit(CollaboratorLoading());
      final collaboratorData = await adminRepository.getCollaboratorsToAdmin();
      print('Collaborator from database: $collaboratorData');
      final isLastPage = collaboratorData.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(collaboratorData);
      } else {
        pagingController.appendPage(collaboratorData, page + 1);
      }
      emit(CollaboratorLoaded(collaboratorData));
    } catch (e) {
      emit(CollaboratorFailure(e.toString()));
      pagingController.error = e;
      print(e.toString());
    }
  }

  Future<void> setStatusToCollaborator(int collaboratorId, int selectStatus) async {
    try {
      emit(CollaboratorLoading());
      await adminRepository.setStatusToCollaborator(collaboratorId, selectStatus);
      emit(CollaboratorDone());
    } catch (e) {
      emit(CollaboratorFailure(e.toString()));
      print(e.toString());
    }
  }
}
