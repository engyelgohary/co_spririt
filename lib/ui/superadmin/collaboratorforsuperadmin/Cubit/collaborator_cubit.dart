import 'package:bloc/bloc.dart';
import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import '../../../../../../data/repository/repoContract.dart';
part 'collaborator_state.dart';

class CollaboratorCubit extends Cubit<CollaboratorState> {
  final CollaboratorRepository collaboratorRepository;
  final PagingController<int, Collaborator> pagingController = PagingController(firstPageKey: 1);

  CollaboratorCubit({required this.collaboratorRepository}) : super(CollaboratorInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      fetchCollaborators(pageKey);
    });
  }

  void fetchCollaborators(int pageKey) async {
    if (state is! CollaboratorLoading) {
      emit(CollaboratorLoading());
    }
    try {
      print("Fetching collaborators for page: $pageKey");
      final collaborators = await collaboratorRepository.fetchAllCollaborators(page: pageKey);
      final isLastPage = collaborators.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(collaborators);
      } else {
        pagingController.appendPage(collaborators, pageKey + 1);
      }
      emit(CollaboratorSuccess(getCollaborator: collaborators));
    } catch (error) {
      print("Error fetching collaborators: $error");
      emit(CollaboratorError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }
  Future<void> deleteCollaborator(int id) async {
    try {
      emit(CollaboratorLoading());
      await collaboratorRepository.deleteCollaborator(id);
      emit(CollaboratorSuccess());
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(CollaboratorError(errorMessage: e.toString()));
    }
  }
}