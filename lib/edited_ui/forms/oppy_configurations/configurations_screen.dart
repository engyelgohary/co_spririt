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
          } else if (state is CubitSuccessState) {
            // Handle the success response correctly based on the type
            List<Customer> customers = [];
            List<Feasibility> feasibilities = [];
            List<Risk> risks = [];
            List<Solution> solutions = [];
            List<Team> teams = [];

            // Populate the lists based on the response
            if (state.response is List<Customer>) {
              customers = List<Customer>.from(state.response);
            } else if (state.response is List<Feasibility>) {
              feasibilities = List<Feasibility>.from(state.response);
            } else if (state.response is List<Risk>) {
              risks = List<Risk>.from(state.response);
            } else if (state.response is List<Solution>) {
              solutions = List<Solution>.from(state.response);
            } else if (state.response is List<Team>) {
              teams = List<Team>.from(state.response);
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildDropdownWithButtons<Customer>(
                    title: "Customers",
                    items: customers,
                    onAdd: (name) => cubit.addCustomer(name),
                    onDelete: (id) => cubit.deleteCustomer(id),
                  ),
                  _buildDropdownWithButtons<Feasibility>(
                    title: "Feasibilities",
                    items: feasibilities,
                    onAdd: (name) => cubit.addFeasibility([name]),
                    onDelete: (id) => cubit.deleteCustomer(id),
                  ),
                  _buildDropdownWithButtons<Risk>(
                    title: "Risks",
                    items: risks,
                    onAdd: (name) => cubit.addRisk(name),
                    onDelete: (id) => cubit.deleteCustomer(id),
                  ),
                  _buildDropdownWithButtons<Solution>(
                    title: "Solutions",
                    items: solutions,
                    onAdd: (name) => cubit.addSolution(name),
                    onDelete: (id) => cubit.deleteCustomer(id),
                  ),
                  _buildDropdownWithButtons<Team>(
                    title: "Teams",
                    items: teams,
                    onAdd: (name) => cubit.addTeam(name),
                    onDelete: (id) => cubit.deleteCustomer(id),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Unknown state."));
          }
        },
      ),
    );
  }

  Widget _buildDropdownWithButtons<T>({
    required String title,
    required List<T> items,
    required Function(String) onAdd,
    required Function(String) onDelete,
  }) {
    T? selectedValue;

    return Card(
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
            items: items.map((item) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showAddDialog(title: title, onAdd: onAdd);
                },
                icon: const Icon(Icons.add),
                label: const Text("Add"),
              ),
              ElevatedButton.icon(
                onPressed: selectedValue != null
                    ? () {
                  final id = _getId(selectedValue!);
                  onDelete(id);
                }
                    : null,
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
              ),
            ],
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
