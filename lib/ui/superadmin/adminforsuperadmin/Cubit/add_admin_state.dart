part of 'add_admin_cubit.dart';

@immutable
sealed class AddAdminState {}

final class AddAdminInitial extends AddAdminState {}
final class AddAdminLoading extends AddAdminState {}
final class AddAdminError extends AddAdminState {
  String?errorMessage;
  Errors? errors;
  AddAdminError({required this.errorMessage,this.errors});
}
final class AddAdminSuccess extends AddAdminState {
  AdminUser? adminUser;
  List<GetAdmin>? getAdmin;
  AddAdminSuccess({this.adminUser,this.getAdmin});
}
