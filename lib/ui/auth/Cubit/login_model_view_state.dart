part of 'login_model_view_cubit.dart';

@immutable
sealed class LoginModelViewState {}

final class LoginModelViewInitial extends LoginModelViewState {}
final class LoginModelViewLoading extends LoginModelViewState {}
final class LoginModelViewError extends LoginModelViewState {
  final String error;
  LoginModelViewError(this.error);
}
final class LoginModelViewSuccess extends LoginModelViewState {
  final Widget homeScreen;
  LoginModelViewSuccess(this.homeScreen);
}

