import 'package:co_spirit/ui/auth/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/Cubit/cubit_state.dart';
import '../../../core/app_util.dart';
import '../../../data/edited_api/userprofile_apis.dart';
import '../../../data/edited_model/user_profile.dart';

class SettingsCubit extends Cubit<CubitState> {
  final UserProfileApis userProfileApis;

  SettingsCubit({required this.userProfileApis}) : super(CubitInitialState());

  Future<void> fetchCurrentUser() async {
    emit(CubitLoadingState());

    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("No token found. Please log in."));
        return;
      }

      // Fetch current user data
      final response = await userProfileApis.getCurrentUser(token: token);

      if (response != null && response.succeeded) {
        emit(CubitSuccessState<UserProfile>(response.data));
      } else {
        emit(CubitFailureState(response?.message ?? "Failed to fetch user data."));
      }
    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }

  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
  }) async {
    emit(CubitLoadingState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("No token found. Please log in."));
        return;
      }

      final response = await userProfileApis.updateProfile(
        token: token,
        firstName: firstName,
        lastName: lastName,
      );

      if (response != null && response.succeeded) {
        emit(CubitSuccessState<UserProfile>(response.data));
      }else {
          emit(CubitFailureState("No user data returned."));
        }

    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(CubitLoadingState());

    try {
      // Retrieve token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        emit(CubitFailureState("Authentication token not found. Please log in."));
        return;
      }

      // Call the API
      await userProfileApis.updatePassword(
        token: token,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      // Emit success state
      emit(CubitSuccessState("Password updated successfully!"));
    } catch (e) {
      emit(CubitFailureState(e.toString()));    }
  }

  Future<void> logOut() async {
    emit(CubitLoadingState());

    try {
      // Retrieve tokens from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final refreshToken = prefs.getString("refreshToken");

      if (token == null || refreshToken == null) {
        emit(CubitFailureState("No tokens found. Unable to log out."));
        return;
      }

      // Call the logOut API
      await userProfileApis.logOut(
        token: token,
        refreshToken: refreshToken,
      );

      // Clear tokens from SharedPreferences
      await prefs.remove("token");
      await prefs.remove("refreshToken");

      emit(CubitSuccessState("Logged out successfully!"));
      AppUtil.mainNavigator(context, LoginScreen());
    } catch (e) {
      emit(CubitFailureState("Failed to log out: $e"));
    }
  }

}
