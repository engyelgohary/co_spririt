import 'package:co_spirit/data/model/Collaborator.dart';
import 'package:flutter/material.dart';

import '../../../data/model/Client.dart';
import '../adminforsuperadmin/infoAdmin.dart';

class InfoClient extends StatelessWidget {
  final Client? client;
  final List<Collaborator> collaborator;
  const InfoClient({super.key, required this.client, required this.collaborator});
  @override
  String getCollaboratorName(int collaboratorId) {
    final collaborators = collaborator.firstWhere(
        (collaborator) => collaborator.id == collaboratorId,
        orElse: () => Collaborator());
    return collaborators.id != null
        ? '${collaborators.firstName} ${collaborators.lastName}'
        : 'No Collaborator Assigned';
  }

  Widget build(BuildContext context) {
    final collaboratorName = client!.collaboratorId != null
        ? getCollaboratorName(client!.collaboratorId)
        : 'No Collaborator Assigned';
    if (client == null) {
      return const CircularProgressIndicator();
    }
    return Container(
      height: 240,
      width: 369,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          CustomTextInfo(fieldName: 'First Name :', data: "${client!.firstName}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'Last Name : ', data: "${client!.lastName}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'Mobile : ', data: "${client!.contactNumber}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'E-mail : ', data: "${client!.email}"),
          SizedBox(
            height: 16,
          ),
          CustomTextInfo(fieldName: 'Collaborator Name:', data: collaboratorName),
        ],
      ),
    );
  }
}
