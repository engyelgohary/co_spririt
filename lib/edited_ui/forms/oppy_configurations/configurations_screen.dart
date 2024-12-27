import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Cubit/cubit_state.dart';
import '../../../data/edited_model/oppy_configurations.dart';
import 'cubit/configurations_cubit.dart';
import 'cubit/configurations_state.dart';

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  late OppyConfigurationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<OppyConfigurationCubit>(context);

    // Fetch all configurations on screen load
    cubit.fetchCustomers();
    cubit.fetchFeasibilities();
    cubit.fetchRisks();
    cubit.fetchSolutions();
    cubit.fetchTeams();
  }

  void showAddDialog({
    required String title,
    required Function(String) onAdd,
  }) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New $title"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter $title name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              onAdd(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oppy Configurations"),
      ),
      body: BlocBuilder<OppyConfigurationCubit, ConfigurationsState>(
        builder: (context, state) {
          if (state is ConfigurationsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConfigurationsFailureState) {
            return Center(child: Text(state.error));
          } else if (state is CustomersLoadedState) {
            return _buildConfigurationList(
              customers: state.customers,
              cubit: cubit,
              title: "Customers",
              onAdd: cubit.addCustomer,
            );
          } else if (state is FeasibilitiesLoadedState) {
            return _buildConfigurationList(
              customers: state.feasibilities,
              cubit: cubit,
              title: "Feasibilities",
              onAdd: (name) => cubit.addFeasibility([name]),
            );
          } else if (state is RisksLoadedState) {
            return _buildConfigurationList(
              customers: state.risks,
              cubit: cubit,
              title: "Risks",
              onAdd: cubit.addRisk,
            );
          } else if (state is SolutionsLoadedState) {
            return _buildConfigurationList(
              customers: state.solutions,
              cubit: cubit,
              title: "Solutions",
              onAdd: cubit.addSolution,
            );
          } else if (state is TeamsLoadedState) {
            return _buildConfigurationList(
              customers: state.teams,
              cubit: cubit,
              title: "Teams",
              onAdd: cubit.addTeam,
            );
          } else {
            return const Center(child: Text("Unknown state."));
          }
        },
      ),
    );
  }

  Widget _buildConfigurationList<T>({
    required String title,
    required List<T> customers,
    required Function(String) onAdd,
    required OppyConfigurationCubit cubit,
  }) {
    T? selectedValue;

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<T>(
                  value: selectedValue,
                  hint: Text("Select $title"),
                  isExpanded: true,
                  items: customers.map((item) {
                    final id = _getId(item); // Get the ID dynamically
                    final name = _getName(item); // Get the name dynamically
                    return DropdownMenuItem(
                      value: item,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showAddDialog(title: title, onAdd: onAdd);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getId<T>(T item) {
    if (item is Customer) return item.id;
    if (item is Feasibility) return item.id;
    if (item is Risk) return item.id;
    if (item is Solution) return item.id;
    if (item is Team) return item.id;
    return "";
  }

  String _getName<T>(T item) {
    if (item is Customer) return item.name;
    if (item is Feasibility) return item.name;
    if (item is Risk) return item.name;
    if (item is Solution) return item.name;
    if (item is Team) return item.name;
    return "";
  }
}
