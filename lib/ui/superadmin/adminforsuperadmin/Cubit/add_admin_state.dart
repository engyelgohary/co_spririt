part of 'add_admin_cubit.dart';

@immutable
sealed class AddAdminState {}

final class AddAdminInitial extends AddAdminState {}
final class AddAdminLoading extends AddAdminState {}
final class AddAdminError extends AddAdminState {
  String?errorMessage;
  AddAdminError({required this.errorMessage,});
}
final class AddAdminSuccess extends AddAdminState {
   GetAdmin? adminData;
  List<GetAdmin>? getAdmin;
  AddAdminSuccess({this.getAdmin,this.adminData});
}
class AddAdminImageSelected extends AddAdminState {
  final XFile image;
  AddAdminImageSelected(this.image);
}