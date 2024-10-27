sealed class CubitState {}

final class CubitInitialState extends CubitState {}

final class CubitLoadingState extends CubitState {}

final class CubitSuccessState<T> extends CubitState {
  final T response;
  CubitSuccessState(this.response);
}

final class CubitFailureState extends CubitState {
  final String error;
  CubitFailureState(this.error);
}
