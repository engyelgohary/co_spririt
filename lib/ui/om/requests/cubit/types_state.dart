part of 'types_cubit.dart';

@immutable
sealed class TypesState {}

final class TypesInitial extends TypesState {}
final class TypesLoading extends TypesState {}
final class TypesError extends TypesState {
  String?errorMessage;
  TypesError({required this.errorMessage,});
}
final class TypesSuccess extends TypesState {
  Types? typeData;
  List<Types>? getType;
  TypesSuccess({this.getType,this.typeData});
}