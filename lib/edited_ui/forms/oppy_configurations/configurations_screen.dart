import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/Cubit/cubit_state.dart';
import '../../../data/edited_api/oppyconfigurations_apis.dart';
import 'configurations_cubit.dart';

class ConfigurationsScreen extends StatefulWidget {
  const ConfigurationsScreen({Key? key}) : super(key: key);

  @override
  _ConfigurationsScreenState createState() => _ConfigurationsScreenState();
}

class _ConfigurationsScreenState extends State<ConfigurationsScreen> {
  String? token;
  String? selectedCustomerConfig;
  String? selectedFeasibilityConfig;
  String? selectedRiskConfig;
  String? selectedPointPrizeConfig;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Load the token from SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create: (_) => ConfigurationsCubit(oppyConfigurationApis: OppyConfigurationApis()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Configurations')),
        body: BlocConsumer<ConfigurationsCubit, CubitState>(
          listener: (context, state) {
            if (state is CubitFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is CubitSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success: ${state.response}")));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Customer Dropdown
                  _buildDropdown("Customer", selectedCustomerConfig, (value) {
                    setState(() {
                      selectedCustomerConfig = value;
                    });
                    context.read<ConfigurationsCubit>().fetchData(token!, "Customer");
                  }, state),
                  // Feasibility Dropdown
                  _buildDropdown("Feasibility", selectedFeasibilityConfig, (value) {
                    setState(() {
                      selectedFeasibilityConfig = value;
                    });
                    context.read<ConfigurationsCubit>().fetchData(token!, "Feasibility");
                  }, state),
                  // Risk Dropdown
                  _buildDropdown("Risk", selectedRiskConfig, (value) {
                    setState(() {
                      selectedRiskConfig = value;
                    });
                    context.read<ConfigurationsCubit>().fetchData(token!, "Risk");
                  }, state),
                  // PointPrize Dropdown
                  _buildDropdown("PointPrize", selectedPointPrizeConfig, (value) {
                    setState(() {
                      selectedPointPrizeConfig = value;
                    });
                    context.read<ConfigurationsCubit>().fetchData(token!, "PointPrize");
                  }, state),
                  if (state is CubitLoadingState)
                    const CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper function to create a dropdown
  Widget _buildDropdown(String configType, String? selectedConfig, Function(String?) onChanged, CubitState state) {
    List<String>? configList = [];
    if (state is CubitSuccessState) {
      // Dynamically populate the dropdown items based on fetched data
      configList = (state.response as List).map((e) => e['name'] ?? 'Unnamed Item').cast<String>().toList();
    }

    return Column(
      children: [
        // Dropdown for each configuration type
        DropdownButton<String>(
          value: selectedConfig,
          items: configList
              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
        if (state is CubitSuccessState)
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: (state.response as List).length,
              itemBuilder: (context, index) {
                var item = state.response[index];
                return ListTile(
                  title: Text(item['name'] ?? 'Unnamed Item'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<ConfigurationsCubit>().deleteData(token!, configType, item['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ElevatedButton(
          onPressed: () {
            _showAddDialog(context, configType);
          },
          child: const Text("Add New Data"),
        ),
      ],
    );
  }

  // Function to show the dialog to add new data
  void _showAddDialog(BuildContext context, String configType) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New $configType"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Map<String, dynamic> data = {'name': nameController.text};
                context.read<ConfigurationsCubit>().addData(token!, configType, data);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
