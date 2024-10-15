import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/repository/data_source.dart';
import 'package:flutter/material.dart';

part 'project_overview_state.dart';

class ProjectOverviewCubit extends Cubit<ProjectsOverviewState> {
  SMDataSource smDataSource;
  ProjectOverviewCubit({required this.smDataSource}) : super(ProjectsOverviewInitialState());

  Future<void> getProjectsOverview() async {
    emit(ProjectsOverviewLoadingState());
    try {
      final tasks = await smDataSource.getTasks();
      Map tasksMap = {};
      for (var task in tasks) {
        if (!tasksMap.containsKey(task["projectName"])) {
          tasksMap[task["projectName"]] = [];
        }
        tasksMap[task["projectName"]].add(task);
      }
      emit(ProjectsOverviewSuccessfulState(tasksMap));
    } catch (e) {
      print("- taskCategoryList error : $e");
      emit(ProjectsOverviewFailureState(e.toString()));
    }
  }
  // Future<void> submit() async {
  //   if (!formKey.currentState!.validate()) return;
  //   emit(OpportunityLoading());
  //   try {
  //     final opportunity = Opportunities(
  //       title: titleController.text,
  //       description: descriptionController.text,
  //       clientId: selectedClientId,
  //     );
  //     await smDataSource.submitOpportunity(opportunity, descriptionFile);
  //     emit(OpportunitySuccess());
  //     fetchOpportunityData();
  //     print('Fetched opportunities: $opportunity'); // Debug statement
  //   } catch (e) {
  //     emit(OpportunityFailure(e.toString()));
  //   }
  // }

  // Future<void> fetchClients() async {
  //   try {
  //     final fetchedClients = await smDataSource.fetchClientsByCollaborator();
  //     clients = fetchedClients;
  //     emit(OpportunitiesClientsFetched(clients)); // Emit a new state when clients are fetched
  //   } catch (e) {
  //     emit(OpportunityFailure('Failed to load clients: $e'));
  //     print(e.toString());
  //   }
  // }

  // void setSelectedClientId(int? clientId) {
  //   selectedClientId = clientId;
  // }

  // Future<void> fetchOpportunityData() async {
  //   try {
  //     emit(OpportunityLoading());

  //     final opportunities = await smDataSource.getOpportunityData();
  //     final clients = await smDataSource.fetchClientsByCollaborator();

  //     final opportunitiesWithClients = opportunities.map((opportunity) {
  //       final client = clients.firstWhere(
  //         (client) => client.id == opportunity.clientId,
  //         orElse: () => Client(id: 0, firstName: 'Unknown', lastName: ''),
  //       );
  //       return Opportunities(
  //           id: opportunity.id,
  //           title: opportunity.title,
  //           description: opportunity.description,
  //           clientId: opportunity.clientId,
  //           clientFirstName: client.firstName,
  //           clientLastName: client.lastName,
  //           descriptionLocation: opportunity.descriptionLocation // Ensure this is correctly mapped
  //           );
  //     }).toList();

  //     print('Opportunities from database: $opportunitiesWithClients'); // Debug statement
  //     emit(OpportunityLoaded(opportunitiesWithClients));
  //   } catch (e) {
  //     emit(OpportunityFailure(e.toString()));
  //     print(e.toString());
  //   }
  // }

  // Future<void> deleteOpportunity(int id) async {
  //   try {
  //     emit(OpportunityLoading());
  //     await smDataSource.deleteOpportunities(id);
  //     await fetchOpportunityData();
  //   } catch (e) {
  //     emit(OpportunityFailure(e.toString()));
  //     print(e.toString());
  //   }
  // }
}
