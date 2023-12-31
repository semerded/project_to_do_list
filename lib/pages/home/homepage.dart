import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/functions/savefile_handeling/file_reader.dart';
import 'package:project_to_do_list/pages/home/filter/priority_filter.dart';
import 'package:project_to_do_list/pages/home/filter/search_filter.dart';
import 'package:project_to_do_list/pages/home/filter/tasktype_filter.dart';
import 'package:project_to_do_list/pages/addtask.dart';
import 'package:project_to_do_list/pages/home/filter/tasktype_x_button.dart';
import 'package:project_to_do_list/pages/settings.dart';
import 'place_todo_task.dart';

// make it so that when a task with 0 subtasks is completed, the slider will go to 100

class APP extends StatefulWidget {
  const APP({super.key});

  @override
  State<APP> createState() => _APPState();
}

class _APPState extends State<APP> {
  Map filterTaskByTaskType = {};
  @override
  void initState() {
    super.initState();
    for (String taskType in taskTypeCatergories) {
      filterTaskByTaskType[taskType] = true;
    }
    readLocalJSONtoDoTaskSaveFile().then((Map value) {
      setState(() {
        toDoTasks = value;
      });
    });
  }

  List filterTaskByPriority = [true, true, true, true];

  String filteredTasksBySearch = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        home: DefaultTabController(
          initialIndex: defaultTab,
          animationDuration: const Duration(milliseconds: 300),
          length: 3,
          child: Scaffold(
            backgroundColor: colorScheme.background,
            appBar: AppBar(
              backgroundColor: colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.assistant),
                onPressed: () => null,
              ),
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
                FilterBySearch(
                  onChanged: (value) => setState(() {
                    filteredTasksBySearch = value;
                  }),
                ),
                PriorityButton(
                  filterTaskByPriority: filterTaskByPriority,
                  onChanged: (value) => setState(() {
                    filterTaskByPriority = value;
                  }),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      PlaceToDoTasks(
                        currentTab: "toDo",
                        filterTaskTypeBySearch: filteredTasksBySearch,
                        filterTaskByPriority: filterTaskByPriority,
                        filterTaskByTaskType: filterTaskByTaskType,
                      ),
                      PlaceToDoTasks(
                        currentTab: "inProgress",
                        filterTaskTypeBySearch: filteredTasksBySearch,
                        filterTaskByPriority: filterTaskByPriority,
                        filterTaskByTaskType: filterTaskByTaskType,
                      ),
                      PlaceToDoTasks(
                        currentTab: "completed",
                        filterTaskTypeBySearch: filteredTasksBySearch,
                        filterTaskByPriority: filterTaskByPriority,
                        filterTaskByTaskType: filterTaskByTaskType,
                      ),
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
                FloatingActionButton(
                  onPressed: () => setState(() {
                    filterTaskByTaskType = hideShowAllTaskTypes(filterTaskByTaskType);
                  }),
                  backgroundColor: colorScheme.card,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: colorScheme.text,
                      width: 1,
                    ),
                  ),
                  mini: true,
                  child: checkIfAllTaskTypesAreEnabled(filterTaskByTaskType)
                      ? Icon(
                          Icons.cancel_outlined,
                          color: colorScheme.text,
                        )
                      : Icon(
                          Icons.check_box_outlined,
                          color: colorScheme.text,
                        ),
                ),
                Flexible(
                  child: SizedBox(
                    height: 30,
                    child: FilterTaskTypeButton(
                      filterTaskByTasktype: filterTaskByTaskType,
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
