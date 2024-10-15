import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:meta/meta.dart';
import 'package:co_spirit/data/repository/repoContract.dart';
import '../../../../data/model/Client.dart';
import '../../../../data/model/opportunities.dart';

part 'opportunites_admin_state.dart';

class OpportunitiesAdminCubit extends Cubit<OpportunitiesAdminState> {
  OpportunitiesRepository opportunitiesRepository;
  ClientRepository clientRepository;
  CollaboratorRepository collaboratorRepository;
  OpportunitiesAdminCubit(
      {required this.opportunitiesRepository,
      required this.clientRepository,
      required this.collaboratorRepository})
      : super(OpportunitiesAdminInitial());
  Future<void> fetchOpportunityData() async {
    try {
      emit(OpportunityLoading());

      final opportunities = await opportunitiesRepository.getOpportunityDataAdmin();
      final clients = await clientRepository.fetchAllClients();
      final collaborators = await collaboratorRepository.fetchAllCollaborators();

      final opportunitiesWithClients = opportunities.map((opportunity) {
        final client = clients.firstWhere(
          (client) => client.id == opportunity.clientId,
          orElse: () => Client(id: 0, firstName: 'Unknown', lastName: ''),
        );
        final collaborator = collaborators.firstWhere(
          (collaborator) => collaborator.id == opportunity.collaboratorId,
          orElse: () => Collaborator(id: 0, firstName: 'Unknown', lastName: ''),
        );
        return Opportunities(
            id: opportunity.id,
            title: opportunity.title,
            description: opportunity.description,
            clientId: opportunity.clientId,
            clientFirstName: client.firstName,
            clientLastName: client.lastName,
            collaboratorFirstName: collaborator.firstName,
            collaboratorLastName: collaborator.lastName,
            collaboratorId: opportunity.collaboratorId,
            descriptionLocation: opportunity.descriptionLocation // Ensure this is correctly mapped
            );
      }).toList();

      print('Opportunities from database: $opportunitiesWithClients'); // Debug statement
      emit(OpportunityLoaded(opportunitiesWithClients));
    } catch (e) {
      emit(OpportunityFailure(e.toString()));
      print(e.toString());
    }
  }
}
