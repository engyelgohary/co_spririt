import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/Cubit/cubit_state.dart';
import '../../core/app_ui.dart';
import '../../data/api/users_api.dart';
import '../../data/edited_model/user.dart';
import 'cubit/user_management_cubit.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<User> users = [];
  List<Role> roles = [];

  String? selectedName;
  String? selectedEmail;
  String? selectedRole;

  List<String?> uniqueNames = [];
  List<String?> uniqueEmails = [];
  List<String?> uniqueRoles = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchRoles();
  }

  Future<void> _fetchUsers() async {
    final cubit = context.read<UserManagementCubit>();
    await cubit.fetchUsers();
  }

  Future<void> _fetchRoles() async {
    final cubit = context.read<UserManagementCubit>();
    await cubit.fetchRoles();
  }

  void extractUniqueValues() {
    uniqueNames = _extractUniqueValues(users.map((user) => user.firstName));
    uniqueEmails = _extractUniqueValues(users.map((user) => user.email));
    uniqueRoles = _extractUniqueValues(users.map((user) => user.role));
  }

  List<String?> _extractUniqueValues(Iterable<String?> items) {
    return ['All', ...items.where((item) => item != null).toSet()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserManagementCubit, CubitState>(builder: (context, state) {
        if (state is CubitLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CubitSuccessState<List<User>>) {
          users = state.response;
          extractUniqueValues();
          return buildUsersContent(context);
        } else if (state is CubitFailureState) {
          return Center(child: Text(state.error));
        }
        return Center(child: Text("No data available."));
      }),
    );
  }

  Widget buildUsersContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Users:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppUI.omSecondColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildDropdownMenu(
                    'Name',
                    uniqueNames,
                    selectedName,
                        (value) {
                      setState(() {
                        selectedName = value == 'All' ? null : value;
                      });
                    },
                  ),
                  buildDropdownMenu(
                    'Email',
                    uniqueEmails,
                    selectedEmail,
                        (value) {
                      setState(() {
                        selectedEmail = value == 'All' ? null : value;
                      });
                    },
                  ),
                  buildDropdownMenu(
                    'Role',
                    uniqueRoles,
                    selectedRole,
                        (value) {
                      setState(() {
                        selectedRole = value == 'All' ? null : value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: users.isEmpty ? 100 : users.length * 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                border: Border.all(
                  color: AppUI.omSecondColor,
                  width: 0.5,
                ),
              ),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if ((selectedName == null || user.firstName == selectedName) &&
                      (selectedEmail == null || user.email == selectedEmail) &&
                      (selectedRole == null || user.role == selectedRole)) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            user.firstName ?? 'No Name',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            user.email ?? 'No Email',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            user.role ?? 'No Role',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 11,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showChangeRoleMenu(context);
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeRoleMenu(BuildContext context) {
    print("Roles fetched: $roles"); // This will show the content of the roles in the console
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Roles"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: roles.isEmpty
                ? [Text("No roles available.")]
                : roles.map((role) {
              print("Role: ${role.name}"); // Debugging line
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(role.name ?? "No Role", style: TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without making changes
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }



  void _changeUserRole(User user, String newRole) async {
    final cubit = context.read<UserManagementCubit>();
    final token = await _getToken();

    if (token != null) {
      try {
        final role = roles.firstWhere((role) => role.name == newRole);
        await cubit.assignRoleToUser(user.id, role.id);

        // Update the user's role locally after success
        setState(() {
          user.role = newRole; // Update UI
        });
      } catch (e) {
        print("Error assigning role: $e");
      }
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Widget buildDropdownMenu(
      String title,
      List<String?> options,
      String? selectedValue,
      ValueChanged<String?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 100,
        child: DropdownButton<String?>(
          isExpanded: true,
          hint: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          value: selectedValue,
          items: options.map((String? value) {
            return DropdownMenuItem<String?>(
              value: value,
              child: Text(value ?? 'No Data'),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
