import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';

class OpportunityDetectorSettings extends StatefulWidget {
  const OpportunityDetectorSettings({super.key});

  @override
  State<OpportunityDetectorSettings> createState() => _OpportunityDetectorSettingsState();
}

class _OpportunityDetectorSettingsState extends State<OpportunityDetectorSettings> {
  final TextEditingController risk = TextEditingController();
  final TextEditingController solution = TextEditingController();
  final TextEditingController status = TextEditingController();
  final TextEditingController scoreStatus = TextEditingController();
  final TextEditingController reward = TextEditingController();
  final TextEditingController scoreReward = TextEditingController();
  final ApiManager apiManager = ApiManager.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Opportunity Detector Settings',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextFormField(fieldName: "Risk", controller: risk),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: "View",
                  functionality: () async {
                    await viewButton(context, apiManager.getRisks, apiManager.deleteRisk);
                  },
                ),
                CustomButton(
                  label: "Add",
                  functionality: () async {
                    await addButton(context, () async {
                      if (risk.text.isNotEmpty) {
                        await apiManager.addRisk(risk.text);
                      }
                    });
                  },
                ),
              ],
            ),
            CustomTextFormField(fieldName: "Solution", controller: solution),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: "View",
                  functionality: () async {
                    await viewButton(context, apiManager.getSolutions, apiManager.deleteSolution);
                  },
                ),
                CustomButton(
                  label: "Add",
                  functionality: () async {
                    await addButton(context, () async {
                      if (solution.text.isNotEmpty) {
                        await apiManager.addSolution(solution.text);
                      }
                    });
                  },
                ),
              ],
            ),
            CustomDoubleTextFormField(
              hintText1: "Score",
              hintText2: "Status",
              fieldName: "Status",
              controller1: scoreStatus,
              controller2: status,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: "View",
                  functionality: () async {
                    await viewButton(context, apiManager.getOpportunityStatus,
                        apiManager.deleteOpportunityStatus);
                  },
                ),
                CustomButton(
                  label: "Add",
                  functionality: () async {
                    await addButton(context, () async {
                      int? score = int.tryParse(scoreStatus.text);
                      if (status.text.isNotEmpty && score != null) {
                        await apiManager.addOpportunityStatus(status.text, score);
                      }
                    });
                  },
                ),
              ],
            ),
            CustomDoubleTextFormField(
              hintText1: "Score",
              hintText2: "Reward",
              fieldName: "Score",
              controller1: scoreReward,
              controller2: reward,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: "View",
                  functionality: () async {
                    await viewButton(context, apiManager.getScore, apiManager.deleteScore);
                  },
                ),
                CustomButton(
                  label: "Add",
                  functionality: () async {
                    if (reward.text.isNotEmpty && scoreReward.text.isNotEmpty) {
                      await addButton(context, () async {
                        if (risk.text.isNotEmpty) {
                          await apiManager.addScore(
                              reward.text, int.tryParse(scoreReward.text) ?? 0);
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addButton(BuildContext context, VoidCallback addFunction) async {
    try {
      loadingIndicatorDialog(context);
      addFunction();
      Navigator.of(context).pop();
      snackBar(context, "Added successfully");
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      snackBar(context, "Add was not successful");
    }
  }

  Future<void> viewButton(
    BuildContext context,
    dynamic Function() list,
    dynamic Function(int) delete,
  ) async {
    loadingIndicatorDialog(context);
    try {
      final data = await list();
      Navigator.of(context).pop();
      listItems(context, data, delete);
    } catch (e) {
      print("Could not load data list");
      Navigator.of(context).pop();
    }
  }

  void listItems(BuildContext context, List<dynamic> data, Function(int id) delete) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 200,
            height: 200,
            child: data.isEmpty
                ? const Center(
                    child: Text("noting to display"),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        data[index]["value"] == null
                            ? data[index]["score"] != null
                                ? Text(
                                    "${index + 1} - ${data[index]["name"]} - ${data[index]["score"]}")
                                : Text("${index + 1} - ${data[index]["name"]}")
                            : Text(
                                "${index + 1} - ${data[index]["name"]} - ${data[index]["value"]}"),
                        IconButton(
                          onPressed: () async {
                            try {
                              loadingIndicatorDialog(context);
                              await delete(data[index]["id"]);
                              snackBar(context, "Deleted successfully");
                            } catch (e) {
                              snackBar(context, "Deletion was not Successful");
                            } finally {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ok"),
            )
          ],
        );
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback functionality;
  const CustomButton({
    super.key,
    required this.label,
    required this.functionality,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
      child: SizedBox(
        height: 35.h,
        width: 135.w,
        child: ElevatedButton(
          onPressed: functionality,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.buttonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.r)))),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 16, color: AppColor.whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}
