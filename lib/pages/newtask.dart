import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/enums.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/functions/savefile_handeling/file_writer.dart';
import 'package:project_to_do_list/functions/show_dialog.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String taskTitle = "New Task";
  String taskType = taskTypeCatergories[0];
  Map<String, bool> criteriasFilledIn = {"title": false, "taskType": true, "priority": false};
  Map newTaskData = {"title": "", "description": "", "taskType": "", "priority": "", "subtasks": []};

  bool checkIfAllCriteriaIsFilledIn(criteriaList) {
    bool allCriteriaFilledIn = true;
    for (var item in criteriaList.values) {
      if (item == false) {
        allCriteriaFilledIn = false;
      }
    }
    return allCriteriaFilledIn;
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

  RoundedRectangleBorder priorityBorder() {
    return RoundedRectangleBorder(
      side: const BorderSide(width: 3, color: Colors.white),
      borderRadius: BorderRadius.circular(5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                priorityButton(Priority.none),
                priorityButton(Priority.low),
                priorityButton(Priority.medium),
                priorityButton(Priority.high),
              ],
            ),
          ),
          Container(
            color: Colors.grey[700],
            child: DropdownButton(
              dropdownColor: Colors.grey[700],
              isExpanded: true,
              hint: Text("selected task type: $taskType"),
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.keyboard_arrow_down),
              padding: const EdgeInsets.all(10),
              items: taskTypeCatergories.map(
                (String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: (value) {
                newTaskData["taskType"] = value!;
                setState(() {
                  taskType = value;
                  criteriasFilledIn["taskType"] = true;
                });
              },
            ),
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
    );
  }
}
