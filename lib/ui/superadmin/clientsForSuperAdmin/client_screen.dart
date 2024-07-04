
import 'package:co_spririt/ui/superadmin/clientsForSuperAdmin/add_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';





class ClientScreenfoSuper extends StatefulWidget {
  const ClientScreenfoSuper({super.key});

  @override
  State<ClientScreenfoSuper> createState() => _ClientScreenfoSuperState();
}

class _ClientScreenfoSuperState extends State<ClientScreenfoSuper> {
  final List<Client> clients = List.generate(
    10,
        (index) => Client(
      name: 'Matteo',
      email: 'MR@email.com',
      avatarUrl: '', // Placeholder image URL
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
        actions: [
          IconButton(
            icon: CircleAvatar(
                radius: 25.r, // Adjust the radius as needed
                backgroundColor: AppColor.secondColor,
                child: Icon(Icons.person_add_alt_outlined, color: AppColor.whiteColor,size: 20,)),
            onPressed: () {
              showAddBottomSheet();
            },
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
            color: AppColor.whiteColor,
            thickness: 1,
          );
        },
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return AdminTile(admin: clients[index]);
        },
      ),
    );
  }

  void showAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: FractionallySizedBox(
              heightFactor: .87, // Adjust this value as needed
              child: AddClientScreen()
          ),
        );
      },);
  }
}

class AdminTile extends StatelessWidget {
  final Client admin;

  AdminTile({required this.admin});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(admin.avatarUrl),
      ),
      title: Text(admin.name, style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(fontWeight: FontWeight.w700)),
      subtitle: Text(admin.email, style: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(fontWeight: FontWeight.w400, fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppColor.SkyColor,
            radius: 18.r,
            child: Icon(
              Icons.update_outlined,
              color: AppColor.secondColor,
              size: 20,
            ),
          ),
          SizedBox(width: 16.w,),
          CircleAvatar(
            backgroundColor: AppColor.SkyColor,
            radius: 18.r,
            child: Icon(
              Icons.info_outline,
              color: AppColor.secondColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class Client {
  final String name;
  final String email;
  final String avatarUrl;

  Client({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}
