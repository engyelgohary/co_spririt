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
  Map<String, String?> selectedConfigs = {};
  List<String> configTypes = ['Customer', 'Feasibility', 'Risk', 'PointPrize'];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

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
      create: (_) =>
          ConfigurationsCubit(oppyConfigurationApis: OppyConfigurationApis()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Configurations')),
        body: BlocConsumer<ConfigurationsCubit, CubitState>(
          listener: (context, state) {
            if (state is CubitFailureState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is CubitSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Success: ${state.response.toString()}")));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: configTypes.map((configType) {
                  return _buildConfigSection(
                      context, configType, state);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfigSection(
      BuildContext context, String configType, CubitState state) {
    List<Map<String, dynamic>>? configList = [];
    if (state is CubitSuccessState &&
        state.response is List &&
        (state.response as List).isNotEmpty) {
      configList = List<Map<String, dynamic>>.from(state.response);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(configType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        DropdownButton<String>(
          value: selectedConfigs[configType],
          items: configList
              ?.map((item) => DropdownMenuItem<String>(
            value: item['id'].toString(),
            child: Text(item['name'] ?? 'Unnamed Item'),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedConfigs[configType] = value;
            });
          },
          hint: Text("Select $configType Config"),
        ),
        ElevatedButton(
          onPressed: () {
            _showAddDialog(context, configType);
          },
          child: Text("Add $configType"),
        ),
        if (configList != null && configList.isNotEmpty)
          ...configList.map((item) {
            return ListTile(
              title: Text(item['name'] ?? 'Unnamed Item'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context
                      .read<ConfigurationsCubit>()
                      .deleteData(token!, configType, item['id'].toString());
                },
              ),
            );
          }).toList(),
      ],
    );
  }


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
                if (nameController.text.isNotEmpty) {
                  Map<String, dynamic> data = {'name': nameController.text};
                  context
                      .read<ConfigurationsCubit>()
                      .addData(token!, configType, data);
                  Navigator.pop(context);
                }
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
