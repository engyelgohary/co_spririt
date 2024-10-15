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
  RequestsResponse? requestData;
  List<RequestsResponse>? getRequest;
  RequestsSuccess({this.getRequest,this.requestData});
}