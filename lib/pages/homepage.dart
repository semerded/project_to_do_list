import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/functions/global_functions.dart';
import 'package:project_to_do_list/functions/savefile_handeling/file_reader.dart';
import 'package:project_to_do_list/pages/newtask.dart';
import 'package:project_to_do_list/pages/settings.dart';
import 'package:project_to_do_list/pages/viewtask.dart';


class APP extends StatefulWidget {
  const APP({super.key});

  @override
  State<APP> createState() => _APPState();
}

class _APPState extends State<APP> {
  @override
  void initState() {
    super.initState();
    readLocalJSONtoDoTaskSaveFile().then((Map value) {
      setState(() {
        toDoTasks = value;
      });
    });
  }

  bool checkIfTaskIsNotFilteredOut(Map taskData) {
    if (taskData["title"].contains(filteredTasksBySearch)) {
      return true;
    }
    if (!onlySearchInTitle && taskData["description"].contains(filteredTasksBySearch)) {
      return true;
    }
    // if (taskTypesActive[taskData["taskType"]]) {
    //   return true;
    // }
    return false;
  }

  Widget placeToDoTasks(currentTab) {
    try {
    List<dynamic> toDoTasksPerCategoryOfCompletion = toDoTasks[currentTab];
    return ListView.builder(
      itemCount: toDoTasksPerCategoryOfCompletion.length,
      itemBuilder: (context, index) {
        Map toDoTaskPerIndex = toDoTasksPerCategoryOfCompletion[index];
        String taskType = checkIfTaskTypeIsValid(toDoTaskPerIndex["taskType"].toString());
        if (checkIfTaskIsNotFilteredOut(toDoTaskPerIndex)) {
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
                if (currentTab == "toDo") {
                  // return taskTypeText;
                  return IconButton(
                    onPressed: () => setState(() {
                      Map task = toDoTasks["toDo"].removeAt(index);
                      toDoTasks["inProgress"].add(task);
                    }),
                    icon: const Icon(Icons.arrow_forward_outlined),
                  );
                } else if (currentTab == "inProgress") {
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
                    currentTab: currentTab,
                    index: index,
                  ),
                ),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    if (value[0]) {
                      toDoTasks["completed"].add(value[1]);
                      toDoTasks[currentTab].removeAt(index);
                    } else {
                      toDoTasks[currentTab][index] = value[1];
                    }
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
    } catch (error) {
      return Container();
    }
  }

  Widget filterTaskTypeButton() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: taskTypeCatergories.length,
      itemBuilder: (context, index) {
        String taskTypeElement = taskTypeCatergories[index];
        return ElevatedButton(
          onPressed: () => setState(() {
            taskTypesActive[taskTypeElement] = !taskTypesActive[taskTypeElement];
          }),
          style: ElevatedButton.styleFrom(
              backgroundColor: taskTypeCatergoriesColors[taskTypeElement][0],
              shape: taskTypesActive[taskTypeElement]
                  ? RoundedRectangleBorder(
                      side: BorderSide(width: 5, color: colorScheme.text),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    )
                  : null),
          child: Text(
            taskTypeElement,
            style: TextStyle(color: taskTypeCatergoriesColors[taskTypeElement][1] ? Colors.black : Colors.white),
          ),
        );
      },
    );
  }

  String filteredTasksBySearch = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        animationDuration: const Duration(milliseconds: 300),
        length: 3,
        child: Scaffold(
          backgroundColor: colorScheme.background,
          appBar: AppBar(
            backgroundColor: colorScheme.primary,
            title: const Center(
              child: Text("The Project To Do List"),
            ),
            bottom: const TabBar(
              tabs: [Text("To Do"), Text("In Progress"), Text("Completed")],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<bool>(builder: (context) => const SettingsMenu()),
                  ).then(
                    (value) {
                      if (value != null && value) {
                        setState(() {});
                      }
                    },
                  );
                },
                icon: const Icon(Icons.settings),
              )
            ],
          ),

          // main body
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  cursorColor: colorScheme.primary,
                  decoration: InputDecoration(

                      /// when inactive
                      enabledBorder: AppLayout.inactiveBorder(),

                      /// when active
                      focusedBorder: AppLayout.activeBorder(),
                      hintText: "Search for task",
                      hintStyle: TextStyle(color: colorScheme.text),
                      iconColor: colorScheme.primary,
                      icon: const Icon(Icons.search)),
                  style: TextStyle(color: colorScheme.text, decorationColor: colorScheme.primary),
                  onChanged: (value) => setState(() {
                    filteredTasksBySearch = value;
                  }),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    placeToDoTasks("toDo"),
                    placeToDoTasks("inProgress"),
                    placeToDoTasks("completed"),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
              ).then(
                (value) {
                  if (value != null && value) {
                    setState(() {
                      readLocalJSONtoDoTaskSaveFile().then((Map value) {
                        setState(() {
                          toDoTasks = value;
                        });
                      });
                    });
                  }
                },
              );
            },
            backgroundColor: colorScheme.primary,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: colorScheme.text),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Icon(Icons.cancel_outlined, color: colorScheme.text),
              ),
              Flexible(
                child: SizedBox(height: 30, child: filterTaskTypeButton()),
              )
            ],
          ),
        ),
      ),
    );
  }
}