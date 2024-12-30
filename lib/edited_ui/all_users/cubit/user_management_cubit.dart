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

  Future<List<Role>> fetchRoles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("No token found. Please log in."));
        return [];
      }

      final roles = await UserManagementApis().getRoles(token); // Corrected instance access
      emit(CubitSuccessState<List<Role>>(roles));
      return roles;
    } catch (error) {
      emit(CubitFailureState(error.toString()));
      return [];
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

  Future<void> addUser(String firstName, String lastName, String email, String password, String roleId) async {
    emit(CubitLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("No token found. Please log in."));
        return;
      }

      await userManagementApis.addUser(firstName, lastName, email, password, roleId, token);

      emit(CubitSuccessState("User added successfully from cubit."));
    } catch (e) {
      emit(CubitFailureState("Error adding user from cubit: $e"));
    }
  }

}
