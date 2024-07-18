import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:co_spririt/data/repository/repoContract.dart';
import '../../../../data/model/Client.dart';
import '../../../../data/model/opportunities.dart';

part 'opportunities_state.dart';

class OpportunitiesCubit extends Cubit<OpportunitiesState> {
  OpportunitiesRepository opportunitiesRepository;
  OpportunitiesCubit({required this.opportunitiesRepository}) : super(OpportunitiesInitial());

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController(text: "engy");
  final TextEditingController descriptionController = TextEditingController(text: "engy");
  File? descriptionFile;
  List<Client> clients = [];
  int? selectedClientId; // Variable to store the selected client ID

  Future<void> submit() async {
    final opportunity = Opportunities(
      title: titleController.text,
      description: descriptionController.text,
      clientId: selectedClientId, // Use the selected client ID here
    );
    emit(OpportunityLoading());
    try {
      await opportunitiesRepository.submitOpportunity(opportunity, descriptionFile);
      emit(OpportunitySuccess());
    } catch (e) {
      emit(OpportunityFailure(e.toString()));
      print(e.toString());
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
}
