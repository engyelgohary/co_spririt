sealed class CubitState {}

final class CubitInitialState extends CubitState {}

final class CubitLoadingState extends CubitState {}

final class CubitSuccessfulState<T> extends CubitState {
  final T response;
  CubitSuccessfulState(this.response);
}

final class CubitFailureState extends CubitState {
  final String error;
  CubitFailureState(this.error);
}
