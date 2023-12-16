import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/functions/global_functions.dart';
import 'package:project_to_do_list/pages/home/filter_tasks.dart';
import 'package:project_to_do_list/pages/viewtask.dart';

class PlaceToDoTasks extends StatefulWidget {
  final String currentTab;
  final String filterTaskTypeBySearch;
  const PlaceToDoTasks({required this.currentTab, required this.filterTaskTypeBySearch, super.key});

  @override
  State<PlaceToDoTasks> createState() => _PlaceToDoTasksState();
}

class _PlaceToDoTasksState extends State<PlaceToDoTasks> {
  @override
  Widget build(BuildContext context) {
    try {
    List<dynamic> toDoTasksPerCategoryOfCompletion = toDoTasks[widget.currentTab];
    return ListView.builder(
      itemCount: toDoTasksPerCategoryOfCompletion.length,
      itemBuilder: (context, index) {
        Map toDoTaskPerIndex = toDoTasksPerCategoryOfCompletion[index];
        String taskType = checkIfTaskTypeIsValid(toDoTaskPerIndex["taskType"].toString());
        if (checkIfTaskIsNotFilteredOut(toDoTaskPerIndex, widget.filterTaskTypeBySearch)) {
          return Card(
            color: colorScheme.card,
            elevation: 2,
            child: ListTile(
              textColor: colorScheme.text,
              shape: Border(left: BorderSide(width: 10, color: taskPriorityColors[toDoTaskPerIndex["priority"]])),
              title: Text(
                toDoTaskPerIndex["title"].toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                text: TextSpan(
                  text: "[$taskType] ",
                  style: TextStyle(color: taskTypeCatergoriesColors[taskType][0], fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                  children: <TextSpan>[
                    TextSpan(text: toDoTaskPerIndex["description"], style: TextStyle(color: colorScheme.text)),
                  ],
                ),
              ),
              trailing: (() {
                Widget taskTypeText = Text(
                  taskType,
                  style: TextStyle(color: taskTypeCatergoriesColors[taskType][0], fontWeight: FontWeight.bold),
                );
                if (widget.currentTab == "toDo") {
                  // return taskTypeText;
                  return IconButton(
                    onPressed: () => setState(() {
                      Map task = toDoTasks["toDo"].removeAt(index);
                      toDoTasks["inProgress"].add(task);
                    }),
                    icon: const Icon(Icons.arrow_forward_outlined),
                  );
                } else if (widget.currentTab == "inProgress") {
                  return CircularProgressIndicator(
                    value: getTaskCompletion(toDoTaskPerIndex["subtasks"]) / toDoTaskPerIndex["subtasks"].length,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.background,
                  );
                } else {
                  return taskTypeText;
                }
              }()),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowTaskScreen(
                    toDoTaskPerIndex: toDoTaskPerIndex,
                    currentTab: widget.currentTab,
                    index: index,
                  ),
                ),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    if (value[0]) {
                      toDoTasks["completed"].add(value[1]);
                      toDoTasks[widget.currentTab].removeAt(index);
                    } else {
                      toDoTasks[widget.currentTab][index] = value[1];
                    }
                  
                  });
                } else {
                  toDoTasks[widget.currentTab].removeAt(index); // TODO
                }
              }),
            ),
          );
        } else {
          return Container();
        }
      },
    );
    } catch (error) {
      return Container();
    }
  
  }
}

