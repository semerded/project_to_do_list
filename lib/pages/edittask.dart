import 'package:deepcopy/deepcopy.dart';
import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/components/ui/priority_button.dart';
import 'package:project_to_do_list/functions/global_functions.dart';

class EditTaskScreen extends StatefulWidget {
  final Map taskData;
  const EditTaskScreen({required this.taskData, super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTaskScreen> {
  Map unchangedCopyOfCurrentTask = {};
  String taskTitle = "Unknown";
  TextEditingController titleController = TextEditingController();

  Map<String, bool> criteriasFilledIn = {"title": false, "taskType": true, "priority": false};

  @override
  void initState() {
    super.initState();
    unchangedCopyOfCurrentTask = widget.taskData.deepcopy();
    taskTitle = titleController.text = widget.taskData["title"];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          title: Text("edit $taskTitle"),
        ),
        body: Column(children: [
          AppLayout.colorAdaptivText("Edit Title Of Task"),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  color: colorScheme.primary,
                  icon: const Icon(Icons.undo),
                  onPressed: () => setState(() {
                    print(unchangedCopyOfCurrentTask);
                    widget.taskData["title"] = titleController.text  = unchangedCopyOfCurrentTask["title"];
                  }),
                ),
                enabledBorder: AppLayout.inactiveBorder(),
                focusedBorder: AppLayout.activeBorder(),
                errorBorder: AppLayout.inactiveBorder(),
                focusedErrorBorder: AppLayout.activeBorder(),
                hintText: "A title for your project",
                hintStyle: TextStyle(color: colorScheme.text),
              ),
              controller: titleController,
              style: TextStyle(color: colorScheme.text),
              cursorColor: colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  widget.taskData["title"] = value;
                });
              },
            ),
          ),
          SingleClickPriorityButton(
            currentPriority: widget.taskData["priority"],
            buttonCallback: (value) => setState(() {
              widget.taskData["priority"] = value;
            }),
          )
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => null,
          backgroundColor: Colors.grey,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
