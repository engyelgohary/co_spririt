part of 'raci_cubit.dart';

@immutable
sealed class RACIState {}

final class RACIInitialState extends RACIState {}

final class RACILoadingState extends RACIState {}

final class RACISuccessfulState extends RACIState {
  final List response;
  RACISuccessfulState(this.response);
}

final class RACIFailureState extends RACIState {
  final String error;
  RACIFailureState(this.error);
}
