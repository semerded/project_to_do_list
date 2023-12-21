import 'package:deepcopy/deepcopy.dart';
import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/edit_text_field.dart';
import 'package:project_to_do_list/components/ui/priority_button.dart';
import 'package:project_to_do_list/components/ui/select_task_type.dart';

// TODO add tab switching and add save button

class EditTaskScreen extends StatefulWidget {
  final Map taskData;
  final String currentTab;
  const EditTaskScreen({required this.taskData, required this.currentTab, super.key});

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
        body: Column(
          children: [
            TaskEditTextField(
              editDescription: "Title",
              originalText: unchangedCopyOfCurrentTask["title"],
              textFieldCallback: (value) => setState(() {
                widget.taskData["title"] = value;
              }),
            ),
            TaskEditTextField(
              editDescription: "Description",
              originalText: unchangedCopyOfCurrentTask["description"],
              textFieldCallback: (value) => setState(() {
                widget.taskData["description"] = value;
              }),
            ),
            SingleClickPriorityButton(
              currentPriority: widget.taskData["priority"],
              buttonCallback: (value) => setState(() {
                widget.taskData["priority"] = value;
              }),
            ),
            SelectTaskType(
              currentTaskType: widget.taskData["taskType"],
              taskTypeCallback: (value) => setState(() {
                widget.taskData["taskType"] = value;
              }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => print(widget.taskData),
          backgroundColor: Colors.grey,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
