import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/Cubit/cubit_state.dart';
import '../../../data/edited_api/user_management_apis.dart';
import '../../../data/edited_model/user.dart';
import '../../../data/edited_model/role.dart';

class UserManagementCubit extends Cubit<CubitState> {
  final UserManagementApis userManagementApis;

  UserManagementCubit({required this.userManagementApis}) : super(CubitInitialState());

  Future<void> fetchUsers() async {
    emit(CubitLoadingState());

    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("No token found. Please log in."));
        return;
      }

      // Fetch users
      final users = await userManagementApis.getUsers(token);
      print(users);

      emit(CubitSuccessState<List<User>>(users));
    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }

  Future<void> fetchRoles() async {
    emit(CubitLoadingState());

    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("No token found. Please log in."));
        return;
      }

      // Fetch roles
      final roles = await userManagementApis.getRoles(token);
      print("fetched roles: $roles");

      emit(CubitSuccessState<List<Role>>(roles));
    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }

  Future<void> assignRoleToUser(String userId, String roleId) async {
    emit(CubitLoadingState());

    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("No token found. Please log in."));
        return;
      }

      // Assign role to user
      await userManagementApis.assignRoleToUser(userId, roleId, token);
      print("role $roleId is assigned to user $userId");

      emit(CubitSuccessState("Role assigned successfully."));
    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }
}
