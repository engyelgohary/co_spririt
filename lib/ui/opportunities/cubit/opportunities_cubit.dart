import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:flutter/material.dart';
import '../../../../data/model/Client.dart';
import '../../../../data/model/opportunities.dart';

part 'opportunities_state.dart';

class OpportunitiesCubit extends Cubit<OpportunitiesState> {
  OpportunitiesRepositoryRemote opportunitiesRepository;
  OpportunitiesCubit({required this.opportunitiesRepository}) : super(OpportunitiesInitial());

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? descriptionFile;
  List<Client> clients = [];
  int? selectedClientId;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    emit(OpportunityLoading());
    try {
      final opportunity = Opportunities(
        title: titleController.text,
        description: descriptionController.text,
        clientId: selectedClientId,
      );
      await opportunitiesRepository.submitOpportunity(opportunity, descriptionFile);
      emit(OpportunitySuccess());
      fetchOpportunityData();
      print('Fetched opportunities: $opportunity'); // Debug statement
    } catch (e) {
      emit(OpportunityFailure(e.toString()));
    }
  }

  Future<void> fetchClients() async {
    try {
      final fetchedClients = await opportunitiesRepository.fetchClientsByCollaborator();
      clients = fetchedClients;
      emit(OpportunitiesClientsFetched(clients)); // Emit a new state when clients are fetched
    } catch (e) {
      emit(OpportunityFailure('Failed to load clients: $e'));
      print(e.toString());
    }
  }

  void setSelectedClientId(int? clientId) {
    selectedClientId = clientId;
  }

  Future<void> fetchOpportunityData() async {
    try {
      emit(OpportunityLoading());

      final opportunities = await opportunitiesRepository.getOpportunityData();
      final clients = await opportunitiesRepository.fetchClientsByCollaborator();

      final opportunitiesWithClients = opportunities.map((opportunity) {
        final client = clients.firstWhere(
          (client) => client.id == opportunity.clientId,
          orElse: () => Client(id: 0, firstName: 'Unknown', lastName: ''),
        );
        return Opportunities(
            id: opportunity.id,
            title: opportunity.title,
            description: opportunity.description,
            clientId: opportunity.clientId,
            clientFirstName: client.firstName,
            clientLastName: client.lastName,
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

  Future<void> deleteOpportunity(int id) async {
    try {
      emit(OpportunityLoading());
      await opportunitiesRepository.deleteOpportunities(id);
      await fetchOpportunityData();
    } catch (e) {
      emit(OpportunityFailure(e.toString()));
      print(e.toString());
    }
  }
}
