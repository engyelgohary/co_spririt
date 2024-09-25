import 'package:bloc/bloc.dart';
import 'package:co_spirit/data/model/Client.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../data/repository/repoContract.dart';
part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  ClientRepository clientRepository;
  final PagingController<int, Client> pagingController = PagingController(firstPageKey: 1);
  ClientCubit({required this.clientRepository}) : super(ClientInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      fetchClients(pageKey);
    });
  }
  TextEditingController firstName_controller = TextEditingController();
  TextEditingController lastName_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Future<void> fetchClients(int pageKey) async {
    emit(ClientLoading());
    try {
      final clients = await clientRepository.fetchAllClients(page: pageKey);
      final isLastPage = clients.length < 10;
      if (isLastPage) {
        pagingController.appendLastPage(clients);
      } else {
        pagingController.appendPage(clients, pageKey + 1);
      }
      emit(ClientSuccess(getClient: clients));
    } catch (error) {
      emit(ClientError(errorMessage: error.toString()));
      pagingController.error = error;
    }
  }

  Future<void> addClient() async {
    if (!formKey.currentState!.validate()) return;
    emit(ClientLoading());
    try {
      final response = await clientRepository.addClient(firstName_controller.text,
          email_controller.text, lastName_controller.text, phone_controller.text);
      emit(ClientSuccess(clientData: response));
    } catch (e) {
      emit(ClientError(errorMessage: e.toString()));
      print(e.toString());
    }
  }

  Future<void> deleteClient(int id) async {
    try {
      emit(ClientLoading());
      await clientRepository.deleteClient(id);
      emit(ClientSuccess());
      pagingController.refresh(); // Refresh the list
    } catch (e) {
      emit(ClientError(errorMessage: e.toString()));
    }
  }

  Future<void> fetchClientDetails(int id) async {
    try {
      final clientDetails = await clientRepository.fetchClientDetails(id);
      emit(ClientSuccess(clientData: clientDetails));
    } catch (e) {
      emit(ClientError(errorMessage: e.toString()));
    }
  }

  Future<void> updateClient(
      int id, String firstName, String lastName, String email, String contactNumber) async {
    try {
      emit(ClientLoading());
      await clientRepository.updateClient(id, firstName, lastName, email, contactNumber);
      emit(ClientSuccess());
      pagingController.refresh();
    } catch (e) {
      emit(ClientError(errorMessage: e.toString()));
    }
  }
}
