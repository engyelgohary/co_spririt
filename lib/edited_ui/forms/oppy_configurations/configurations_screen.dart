import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_ui.dart';
import '../../../data/edited_model/oppy_configurations.dart';
import 'configuration_cards.dart';
import 'cubit/configurations_cubits.dart';
import 'cubit/configurations_state.dart';


class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  late CustomersCubit customersCubit;
  late FeasibilitiesCubit feasibilitiesCubit;
  late RisksCubit risksCubit;
  late SolutionsCubit solutionsCubit;
  late TeamsCubit teamsCubit;

  @override
  void initState() {
    super.initState();
    customersCubit = BlocProvider.of<CustomersCubit>(context);
    feasibilitiesCubit = BlocProvider.of<FeasibilitiesCubit>(context);
    risksCubit = BlocProvider.of<RisksCubit>(context);
    solutionsCubit = BlocProvider.of<SolutionsCubit>(context);
    teamsCubit = BlocProvider.of<TeamsCubit>(context);

    // Fetch all configurations on screen load
    customersCubit.fetchCustomers();
    feasibilitiesCubit.fetchFeasibilities();
    risksCubit.fetchRisks();
    solutionsCubit.fetchSolutions();
    teamsCubit.fetchTeams();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUI.whiteColor,
        title: const Text(
          " Configurations", style: TextStyle(color: AppUI.omMainColor),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Customers Section
            BlocBuilder<CustomersCubit, ConfigurationsState>(
              builder: (context, state) {
                if (state is ConfigurationsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConfigurationsFailureState) {
                  return Center(child: Text(state.error));
                } else if (state is CustomersLoadedState) {
                  return ConfigurationList<Customer>(
                    title: "Customers",
                    items: state.customers,
                    onAdd: (name) => customersCubit.addCustomer(name),
                    onDelete: (id) => customersCubit.deleteCustomer(id),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Feasibilities Section
            BlocBuilder<FeasibilitiesCubit, ConfigurationsState>(
              builder: (context, state) {
                if (state is ConfigurationsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConfigurationsFailureState) {
                  return Center(child: Text(state.error));
                } else if (state is FeasibilitiesLoadedState) {
                  return ConfigurationList<Feasibility>(
                    title: "Feasibilities",
                    items: state.feasibilities,
                    onAdd: (name) => feasibilitiesCubit.addFeasibility([name]),
                    onDelete: (id) => feasibilitiesCubit.deleteFeasibility(id),

                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Risks Section
            BlocBuilder<RisksCubit, ConfigurationsState>(
              builder: (context, state) {
                if (state is ConfigurationsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConfigurationsFailureState) {
                  print("fetched risks from UI $state");

                  return Center(child: Text(state.error));
                } else if (state is RisksLoadedState) {
                  return ConfigurationList<Risk>(
                    title: "Risks",
                    items: state.risks,
                    onAdd: risksCubit.addRisk,
                    onDelete: (id) => risksCubit.deleteRisk(id),

                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Solutions Section
            BlocBuilder<SolutionsCubit, ConfigurationsState>(
              builder: (context, state) {
                if (state is ConfigurationsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConfigurationsFailureState) {
                  return Center(child: Text(state.error));
                } else if (state is SolutionsLoadedState) {
                  return ConfigurationList<Solution>(
                    title: "Solutions",
                    items: state.solutions,
                    onAdd: solutionsCubit.addSolution,
                    onDelete: (id) => solutionsCubit.deleteSolution(id),

                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Teams Section
            BlocBuilder<TeamsCubit, ConfigurationsState>(
              builder: (context, state) {
                if (state is ConfigurationsLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConfigurationsFailureState) {
                  return Center(child: Text(state.error));
                } else if (state is TeamsLoadedState) {
                  return ConfigurationList<Team>(
                    title: "Teams",
                    items: state.teams,
                    onAdd: teamsCubit.addTeam,
                    onDelete: (id) => teamsCubit.deleteTeam(id),

                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

}