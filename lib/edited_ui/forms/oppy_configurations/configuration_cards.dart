import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../data/edited_model/oppy_configurations.dart';

class ConfigurationList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Function(String) onAdd;
  final Function(String) onDelete;

  const ConfigurationList({
    Key? key,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final id = _getId(item);
                final name = _getName(item);

                return ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      onDelete(id);  // Trigger the delete function
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddDialog(context, title, onAdd);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUI.omMainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extract ID and Name dynamically for all configuration types
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

  void _showAddDialog(BuildContext context, String title, Function(String) onAdd) {
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
}
