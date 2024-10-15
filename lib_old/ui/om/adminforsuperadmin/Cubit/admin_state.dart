part of 'admin_cubit.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}
final class AdminLoading extends AdminState {}
final class AdminError extends AdminState {
  String?errorMessage;
  AdminError({required this.errorMessage,});
}
final class AdminSuccess extends AdminState {
   GetAdmin? adminData;
  List<GetAdmin>? getAdmin;
  AdminSuccess({this.getAdmin,this.adminData});
}
class AdminImageSelected extends AdminState {
  final XFile image;
  AdminImageSelected(this.image);
}