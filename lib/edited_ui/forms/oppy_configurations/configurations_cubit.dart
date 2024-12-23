import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../core/Cubit/cubit_state.dart';
import '../../../data/api_response.dart';
import '../../../data/edited_api/oppyconfigurations_apis.dart';

class ConfigurationsCubit extends Cubit<CubitState> {
  final OppyConfigurationApis oppyConfigurationApis;

  ConfigurationsCubit({required this.oppyConfigurationApis}) : super(CubitInitialState());

  Future<void> fetchData(String token, String configType) async {
    emit(CubitLoadingState());

    try {
      ApiResponse? response;
      switch (configType) {
        case 'Customer':
          response = await oppyConfigurationApis.getCustomers(token: token);
          break;
        case 'Feasibility':
          response = await oppyConfigurationApis.getFeasibilities(token: token);
          break;
        case 'Risk':
          response = await oppyConfigurationApis.getRisks(token: token);
          break;
        case 'PointPrize':
          response = await oppyConfigurationApis.getPointPrizes(token: token);
          break;
        default:
          emit(CubitFailureState("Invalid configuration type"));
          return;
      }

      if (response != null && response.succeeded) {
        emit(CubitSuccessState(response.data)); // Ensure data is emitted here
      } else {
        emit(CubitFailureState(response?.message ?? "Failed to fetch data"));
      }
    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }

  Future<void> addData(String token, String configType, Map<String, dynamic> data) async {
    emit(CubitLoadingState());

    try {
      ApiResponse? response;
      switch (configType) {
        case 'Customer':
          response = await oppyConfigurationApis.addCustomer(token: token, customerData: data);
          break;
        case 'Feasibility':
          response = await oppyConfigurationApis.addFeasibility(token: token, feasibilityData: data);
          break;
        case 'Risk':
          response = await oppyConfigurationApis.addRisk(token: token, riskData: data);
          break;
        case 'PointPrize':
          response = await oppyConfigurationApis.addPointPrize(token: token, pointPrizeData: data);
          break;
        default:
          emit(CubitFailureState("Invalid configuration type"));
          return;
      }

      if (response != null && response.succeeded) {
        await fetchData(token, configType); // Refresh the list
        emit(CubitSuccessState(response.data));
      } else {
        emit(CubitFailureState(response?.message ?? "Failed to add data"));
      }
    } catch (e) {
      emit(CubitFailureState("An error occurred: $e"));
    }
  }

  Future<void> deleteData(String token, String configType, String id) async {
    emit(CubitLoadingState());

    try {
      switch (configType) {
        case 'Customer':
          await oppyConfigurationApis.deleteCustomer(token: token, id: id);
          break;
        case 'Feasibility':
          await oppyConfigurationApis.deleteFeasibility(token: token, id: id);
          break;
        case 'Risk':
          await oppyConfigurationApis.deleteRisk(token: token, id: id);
          break;
        case 'PointPrize':
          await oppyConfigurationApis.deletePointPrize(token: token, id: id);
          break;
        default:
          emit(CubitFailureState("Invalid configuration type"));
          return;
      }

      emit(CubitSuccessState("Data deleted successfully"));
    } catch (e) {
      emit(CubitFailureState("Failed to delete data: $e"));
    }
  }
}
