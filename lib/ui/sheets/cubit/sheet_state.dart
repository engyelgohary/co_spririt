sealed class SheetState {}

final class SheetInitialState extends SheetState {}

final class SheetLoadingState extends SheetState {}

final class SheetSuccessfulState extends SheetState {
  final dynamic response;
  SheetSuccessfulState(this.response);
}

final class SheetFailureState extends SheetState {
  final String error;
  SheetFailureState(this.error);
}
