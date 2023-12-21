import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/enums.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/components/ui/priority_border.dart';
import 'package:project_to_do_list/components/ui/priority_button.dart';
import 'package:project_to_do_list/components/ui/select_task_type.dart';
import 'package:project_to_do_list/functions/global_functions.dart';
import 'package:project_to_do_list/functions/savefile_handeling/file_writer.dart';
import 'package:project_to_do_list/components/ui/show_subtask_dialog.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String taskTitle = "New Task";
  String taskType = taskTypeCatergories.first;
  Map<String, bool> criteriasFilledIn = {"title": false, "taskType": true, "priority": false};
  Map newTaskData = {"title": "", "description": "", "taskType": "", "priority": -1, "subtasks": []};

  @override
  void initState() {
    super.initState();
    newTaskData["taskType"] = taskType;
  }

  Widget priorityButton(Priority priorityLevel) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            newTaskData["priority"] = priorityLevel.index;
            criteriasFilledIn["priority"] = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: taskPriorityColors[priorityLevel.index],
          shape: newTaskData["priority"] == priorityLevel.index ? priorityBorder() : null,
        ),
        child: Text(priorityLevel.name),
      ),
    );
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
          title: Text("Add $taskTitle"),
          backgroundColor: colorScheme.primary,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AppLayout.colorAdaptivText("Title of task"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: AppLayout.inactiveBorder(),
                  focusedBorder: AppLayout.activeBorder(),
                  hintText: "A title for your project",
                  hintStyle: TextStyle(color: colorScheme.text),
                ),
                style: TextStyle(color: colorScheme.text),
                cursorColor: colorScheme.primary,
                onChanged: (value) {
                  newTaskData["title"] = value;
                  setState(() {
                    if (value != "") {
                      taskTitle = value;
                      criteriasFilledIn["title"] = true;
                    } else {
                      taskTitle = "New Task";
                      criteriasFilledIn["title"] = false;
                    }
                  });
                },
              ),
            ),

            ///
            /// add description
            ///
            AppLayout.colorAdaptivText("Description of task"),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: AppLayout.inactiveBorder(),
                  focusedBorder: AppLayout.activeBorder(),
                  errorBorder: AppLayout.inactiveBorder(),
                  focusedErrorBorder: AppLayout.activeBorder(),
                  hintText: "A description for your project",
                  hintStyle: TextStyle(color: colorScheme.text),
                  helperStyle: const TextStyle(color: Colors.red),
                  helperText: newTaskData["description"] == "" && checkIfAllCriteriaIsFilledIn(criteriasFilledIn) ? "maybe it is better to add a description" : null,
                ),
                style: TextStyle(color: colorScheme.text),
                cursorColor: colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    newTaskData["description"] = value;
                  });
                },
              ),
            ),
            SingleClickPriorityButton(
              currentPriority: newTaskData["priority"],
              buttonCallback: (value) => setState(() {
                newTaskData["priority"] = value;
                criteriasFilledIn["priority"] = true;
              }),
            ),
            SelectTaskType(
              currentTaskType: newTaskData["taskType"],
              taskTypeCallback: (value) {
                newTaskData["taskType"] = value;
                setState(() {
                  criteriasFilledIn["taskType"] = true;
                });
              },
            ),
            Column(
              children: [
                Card(
                  elevation: 2,
                  shape: AppLayout.cardBorder(borderRadius: 20, borderColor: colorScheme.primary, borderWidth: 3),
                  color: colorScheme.card,
                  child: ListTile(
                    leading: Icon(
                      Icons.add,
                      color: colorScheme.text,
                    ),
                    title: AppLayout.colorAdaptivText("add subtask"),
                    onTap: () {
                      subTaskDialog(context).then(
                        (value) {
                          if (value != null) {
                            setState(() {
                              newTaskData["subtasks"].add(value);
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: newTaskData["subtasks"].length,
                  itemBuilder: (context, index) {
                    Map subtask = newTaskData["subtasks"][index];
                    return Card(
                      color: colorScheme.card,
                      elevation: 2,
                      child: ListTile(
                        shape: Border(left: BorderSide(width: 10, color: taskPriorityColors[subtask["priority"]])),
                        title: Text(
                          subtask["title"]!,
                          style: TextStyle(color: colorScheme.primary),
                        ),
                        subtitle: AppLayout.colorAdaptivText(subtask["description"]!),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                newTaskData["subtasks"].removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_forever)),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (checkIfAllCriteriaIsFilledIn(criteriasFilledIn)) {
              setState(() {
                toDoTasks["toDo"].add(newTaskData);
                writeLocalJSONtoDoTaskSaveFile(toDoTasks);
                Navigator.of(context).pop(true);
              });
            }
          },
          backgroundColor: checkIfAllCriteriaIsFilledIn(criteriasFilledIn) ? Colors.green : Colors.red,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
