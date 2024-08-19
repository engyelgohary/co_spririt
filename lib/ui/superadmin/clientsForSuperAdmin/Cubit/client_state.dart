part of 'client_cubit.dart';

@immutable
sealed class ClientState {}

final class ClientInitial extends ClientState {}
final class ClientLoading extends ClientState {}
final class ClientError extends ClientState {
  String?errorMessage;
  ClientError({required this.errorMessage,});
}
final class ClientSuccess extends ClientState {
  Client? clientData;
  List<Client>? getClient;
  ClientSuccess({this.getClient,this.clientData});
}
