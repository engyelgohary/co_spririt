import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/Cubit/cubit_state.dart';
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


      } else {
        emit(CubitFailureState(response?.message ?? "Failed to update profile."));
      }
    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }
}
