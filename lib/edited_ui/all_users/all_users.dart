import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Cubit/cubit_state.dart';
import '../../core/app_ui.dart';
import '../../data/edited_model/role.dart';
import '../../data/edited_model/user.dart';
import '../forms/add_user_form.dart';
import 'cubit/user_management_cubit.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<User> users = [];
  var roles = [];

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
    try {
      // Fetch roles using the Cubit method
      final fetchedRoles = await cubit.fetchRoles();

      // Update the state only if the fetched roles are valid
      setState(() {
        roles = fetchedRoles;
      });
    } catch (e) {
      // Handle exceptions and log errors
      print("Error fetching roles: $e");
    }
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
      body: BlocBuilder<UserManagementCubit, CubitState>(
          builder: (context, state) {
        if (state is CubitLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CubitSuccessState<List<User>>) {
          users = state.response;
          print("users from UI $users");
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
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Users:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                  if ((selectedName == null ||
                          user.firstName == selectedName) &&
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            user.role ?? 'No Role',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_outlined, size: 17),
                          onSelected: (value) {
                            if (value == "change_role") {
                              onChangeRole(
                                  context, user.id); // Pass the user ID here
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "change_role",
                              child: Text("Change Role"),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),

            FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Makes the modal resizable based on content
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return AddUserForm(
                      roles: roles.cast<Role>(),
                    );
                  },
                );
              },
              backgroundColor: AppUI.omMainColor,
              child: Icon(
                Icons.add,
                size: 20,
                color: AppUI.whiteColor,
              ),
            ),
          ],
        ),
      ),

    );
  }

  void onChangeRole(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedRoleId; // To hold the selected role ID

        return AlertDialog(
          title: Text("Change Role"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return roles.isNotEmpty
                  ? DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Select a Role"),
                      value: selectedRoleId,
                      items: roles.map((role) {
                        return DropdownMenuItem<String>(
                          value: role.id,
                          child: Text(role.name ?? 'No Role Name'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRoleId = value;
                        });
                      },
                    )
                  : Text("No roles available.");
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (selectedRoleId != null) {
                  final cubit = context.read<UserManagementCubit>();
                  try {
                    // Assign the selected role to the user
                    await cubit.assignRoleToUser(userId, selectedRoleId!);

                    // Re-fetch the users to update the UI with the new roles
                    await cubit.fetchUsers();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Role assigned successfully!")),
                    );
                  } catch (e) {
                    // Show error message if the role assignment fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error assigning role: $e")),
                    );
                  }
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
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
