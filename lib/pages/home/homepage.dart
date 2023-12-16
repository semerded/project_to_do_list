import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/functions/savefile_handeling/file_reader.dart';
import 'package:project_to_do_list/pages/home/filter_tasks.dart';
import 'package:project_to_do_list/pages/newtask.dart';
import 'package:project_to_do_list/pages/settings.dart';
import 'place_todo_task.dart';

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
                    PlaceToDoTasks(
                      currentTab: "toDo",
                      filterTaskTypeBySearch: filteredTasksBySearch,
                    ),
                    PlaceToDoTasks(
                      currentTab: "inProgress",
                      filterTaskTypeBySearch: filteredTasksBySearch,
                    ),
                    PlaceToDoTasks(
                      currentTab: "completed",
                      filterTaskTypeBySearch: filteredTasksBySearch,
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
              const Flexible(
                child: SizedBox(height: 30, child: FilterTaskTypeButton()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
