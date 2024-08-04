part of 'requests_cubit.dart';

@immutable
sealed class RequestsState {}

final class RequestsInitial extends RequestsState {}
final class RequestsLoading extends RequestsState {}
final class RequestsError extends RequestsState {
  String?errorMessage;
  RequestsError({required this.errorMessage,});
}
final class RequestsSuccess extends RequestsState {
  Types? typeData;
  List<Types>? getType;
  RequestsSuccess({this.getType,this.typeData});
}