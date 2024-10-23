import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../data/api/apimanager.dart';
import '../data/model/AllUsers.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  late ApiManager apiManager;
  List<AllUsers> users = [];
  String? selectedName;
  String? selectedEmail;
  String? selectedRole;

  List<String?> uniqueNames = [];
  List<String?> uniqueEmails = [];
  List<String?> uniqueRoles = [];

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstance();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    users = await apiManager.getAllUsers();
    extractUniqueValues();
    setState(() {});
  }

  void extractUniqueValues() {
    uniqueNames = [
      'All',
      ...users.map((user) => user.name).where((name) => name != null).toSet().toList()
    ];
    uniqueEmails = [
      'All',
      ...users.map((user) => user.email).where((email) => email != null).toSet().toList()
    ];
    uniqueRoles = [
      'All',
      ...users.map((user) => user.role).where((role) => role != null).toSet().toList()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Users",
        context: context,
        backArrowColor: OMColorScheme.mainColor,
        textColor: OMColorScheme.textColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Name",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                            color: const Color(0xFF4169E1),
                          ),
                    ),
                    Text(
                      "Email",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                            color: const Color(0xFF4169E1),
                          ),
                    ),
                    Text(
                      "Role",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                            color: const Color(0xFF4169E1),
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      if ((selectedName == null || user.name == selectedName) &&
                          (selectedEmail == null || user.email == selectedEmail) &&
                          (selectedRole == null || user.role == selectedRole)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                user.name ?? 'No Name',
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
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownMenu(
      String title, List<String?> options, String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 100,
        child: DropdownButton<String?>(
          isExpanded: true,
          hint: Text(
            title,
            textAlign: TextAlign.center,
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
