import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/functions/global_functions.dart';
import 'package:project_to_do_list/pages/home/filter/filter_tasks.dart';
import 'package:project_to_do_list/pages/viewtask.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PlaceToDoTasks extends StatefulWidget {
  final String currentTab;
  final String filterTaskTypeBySearch;
  final List filterTaskByPriority;
  const PlaceToDoTasks({required this.currentTab, required this.filterTaskTypeBySearch, required this.filterTaskByPriority, super.key});

  @override
  State<PlaceToDoTasks> createState() => _PlaceToDoTasksState();
}

class _PlaceToDoTasksState extends State<PlaceToDoTasks> {
  String taskCompletionPercentage(List subtasks) {
    double analogPercentage = getTaskCompletion(subtasks) / subtasks.length;
    String percentage = (analogPercentage * 100).toInt().toString();
    return "$percentage%";
  }

  Widget noTaskFoundMessage(String taskTab, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLayout.colorAdaptivText("No tasks $taskTab", fontSize: 25, fontWeight: FontWeight.bold),
        AppLayout.colorAdaptivText(description),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      List<dynamic> toDoTasksPerCategoryOfCompletion = toDoTasks[widget.currentTab];
      if (toDoTasksPerCategoryOfCompletion.isEmpty) {
        return (() {
          if (widget.currentTab == "toDo") {
            return noTaskFoundMessage("to-do", "Add more tasks with the '+'");
          } else if (widget.currentTab == "inProgress") {
            return noTaskFoundMessage("in progress", "Add tasks from the to-do page");
          } else {
            return noTaskFoundMessage("completed", "Start completing your tasks!");
          }
        }());
      } else {
        return ListView.builder(
          itemCount: toDoTasksPerCategoryOfCompletion.length,
          itemBuilder: (context, index) {
            Map toDoTaskPerIndex = toDoTasksPerCategoryOfCompletion[index];
            String taskType = checkIfTaskTypeIsValid(toDoTaskPerIndex["taskType"].toString());
            if (checkIfTaskIsNotFilteredOut(toDoTaskPerIndex, widget.filterTaskTypeBySearch, widget.filterTaskByPriority)) {
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
                    // trailing when tab is in todo
                    if (widget.currentTab == "toDo") {
                      return IconButton(
                        onPressed: () => setState(() {
                          Map task = toDoTasks["toDo"].removeAt(index);
                          toDoTasks["inProgress"].add(task);
                        }),
                        icon: const Icon(Icons.arrow_forward_outlined),
                      );
                      // trailing when tab is in progress
                    } else if (widget.currentTab == "inProgress") {
                      if (toDoTaskPerIndex["subtasks"].length == 0) {
                        return IconButton(
                            onPressed: () => setState(() {
                                  toDoTasks["completed"].add(toDoTaskPerIndex);
                                  toDoTasks["inProgress"].removeAt(index);
                                }),
                            icon: const Icon(Icons.check));
                      } else {
                        return CircularPercentIndicator(
                          radius: 25,
                          lineWidth: 3,
                          percent: getTaskCompletion(toDoTaskPerIndex["subtasks"]) / toDoTaskPerIndex["subtasks"].length,
                          center: AppLayout.colorAdaptivText(taskCompletionPercentage(toDoTaskPerIndex["subtasks"])),
                          progressColor: colorScheme.primary,
                          backgroundColor: colorScheme.background,
                        );
                      }
                      // trailing when tab is in completed
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
                      setState(() {
                        toDoTasks[widget.currentTab].removeAt(index);
                      });
                    }
                  }),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }
    } catch (error) {
      return Expanded(
        child: AppLayout.colorAdaptivText("Loading...\nPlease wait"),
      );
    }
  }
}
