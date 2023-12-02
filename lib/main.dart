import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const String jsonFilePath = "assets/toDoSaveFile.json";

Map<String, dynamic> toDoTasks = {};
List<String> colorSchemeChoice = ['Green', 'Red', 'Blue', 'Orange', 'Purple'];
Map<String, MaterialColor> colorSchemeReference = {'Green': Colors.green, 'Red': Colors.red, 'Blue': Colors.blue, 'Orange': Colors.orange, 'Purple': Colors.purple};

List<String> taskTypeCatergories = ['Real Life', 'Python', 'HTML', 'Java', 'Flutter', 'C++', 'Arduino', 'JavaScript', 'Kotlin', 'My Website', 'Other'];
Map<String, dynamic> taskTypeCatergoriesColors = {
  taskTypeCatergories[0]: Colors.grey,
  taskTypeCatergories[1]: Colors.lightBlue,
  taskTypeCatergories[2]: Colors.orange,
  taskTypeCatergories[3]: Colors.red,
  taskTypeCatergories[4]: Colors.blue[600],
  taskTypeCatergories[5]: Colors.purple,
  taskTypeCatergories[6]: Colors.teal,
  taskTypeCatergories[7]: Colors.yellow[700],
  taskTypeCatergories[8]: Colors.green[900],
  taskTypeCatergories[9]: Colors.green,
  taskTypeCatergories[10]: Colors.black
};
Map<String, dynamic> taskTypesActive = {
  taskTypeCatergories[0]: true,
  taskTypeCatergories[1]: true,
  taskTypeCatergories[2]: true,
  taskTypeCatergories[3]: true,
  taskTypeCatergories[4]: true,
  taskTypeCatergories[5]: true,
  taskTypeCatergories[6]: true,
  taskTypeCatergories[7]: true,
  taskTypeCatergories[8]: true,
  taskTypeCatergories[9]: true,
  taskTypeCatergories[10]: true,
};

Map<String, dynamic> taskPriorityColors = {'none': colorScheme.text, 'low': Colors.green, 'medium': Colors.yellow, 'high': Colors.red};

Map<String, dynamic> userPresets = {"colorSchemeChoice": "Orange", "showProgrammingColor": true, "darkMode": true, "onlySearchInTitle": false};

String accentColor = userPresets["colorSchemeChoice"]; // TODO make json with app settings and add save color scheme in there
bool showProgrammingColor = userPresets["showProgrammingColor"];
bool darkMode = userPresets["darkMode"];
bool onlySearchInTitle = userPresets["onlySearchInTitle"];

// Future<dynamic> write() async {
//   final String jsonString = await rootBundle.loadString(jsonFilePath);
//   return jsonEncode(jsonString);
// }

Future<File> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return File('$path/JSONtaskSaveFile.json');
}

Future<File> writeToJSONtaskSaveFile(jsonDataAsJsonObject) async {
  final file = await _localPath;

  // Write the file
  return file.writeAsString(jsonEncode(jsonDataAsJsonObject));
}

Future<Map<String, dynamic>> readToDoTasksFromJSONtaskSaveFile() async {
  try {
    final file = await _localPath;

    // Read the file
    final contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (e) {
    // If encountering an error, return 0
    return {"toDo": [], "inProgress": [], "completed": []};
  }
}

class APPcolorScheme {
  MaterialColor primary = colorSchemeReference[accentColor]!;
  dynamic background = darkMode ? Colors.grey[900] : Colors.white;
  dynamic text = darkMode ? Colors.white : Colors.grey[900];
  dynamic card = darkMode ? Colors.grey[800] : Colors.white60;

  void setPrimary(newAccentColor) {
    primary = colorSchemeReference[newAccentColor]!;
  }

  void switchLightDarkMode() {
    darkMode = !darkMode;
    background = darkMode ? Colors.grey[900] : Colors.white;
    text = darkMode ? Colors.white : Colors.grey[900];
    card = darkMode ? Colors.grey[800] : Colors.white60;
  }
}

class AppLayout {
  static InputBorder inactiveBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.text,
        width: 2,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }

  static InputBorder activeBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 4,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }

  static ShapeBorder cardBorder({double borderRadius = 10, dynamic borderColor = Colors.white, double borderWidth = 1}) {
    return RoundedRectangleBorder(
      side: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  static Widget colorAdaptivText(text) {
    return Text(
      text,
      style: TextStyle(color: colorScheme.text),
    );
  }
}

class Data {
  // TODO change name
  static String checkIfTaskTypeIsValid(taskTypeOfTask) {
    if (taskTypeCatergories.contains(taskTypeOfTask)) {
      return taskTypeOfTask;
    }
    return "Other";
  }
}

APPcolorScheme colorScheme = APPcolorScheme();

//////////
// main //
//////////
void main() {
  runApp(const MaterialApp(
    home: APP(),
  ));
}

class APP extends StatefulWidget {
  const APP({super.key});

  @override
  State<APP> createState() => _APPState();
}

//////////////////////////
// homepage (task page) //
//////////////////////////
class _APPState extends State<APP> {
  @override
  void initState() {
    super.initState();
    readToDoTasksFromJSONtaskSaveFile().then((Map<String, dynamic> value) {
      setState(() {
        toDoTasks = value;
      });
    });
  }

  bool checkIfTaskIsNotFilteredOut(Map<String, dynamic> taskData) {
    if (taskData["title"].contains(filteredTasksBySearch)) {
      return true;
    }
    if (!onlySearchInTitle && taskData["description"].contains(filteredTasksBySearch)) {
      return true;
    }
    if (taskTypesActive[taskData["taskType"]]) {
      return true;
    }
    return false;
  }

  Widget placeToDoTasks(currentTab) {
    List<dynamic> toDoTasksPerCategoryOfCompletion = toDoTasks[currentTab];
    return ListView.builder(
      itemCount: toDoTasksPerCategoryOfCompletion.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> toDoTaskPerIndex = toDoTasksPerCategoryOfCompletion[index];
        String taskType = Data.checkIfTaskTypeIsValid(toDoTaskPerIndex["taskType"].toString());
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
                style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold), // TODO bold
              ),
              subtitle: Text(
                toDoTaskPerIndex["description"],
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                taskType,
                style: TextStyle(color: taskTypeCatergoriesColors[taskType], fontWeight: FontWeight.bold),
              ),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(toDoTaskPerIndex["title"]),
                  titleTextStyle: TextStyle(color: colorScheme.primary),
                  backgroundColor: colorScheme.background,
                  content: Stack(
                    children: [AppLayout.colorAdaptivText(toDoTaskPerIndex["description"])],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
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
            backgroundColor: taskTypeCatergoriesColors[taskTypeElement],
            shape: taskTypesActive[taskTypeElement] ?  RoundedRectangleBorder(
              side: BorderSide(width: 5, color: colorScheme.text),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ) : null
          ),
          child: Text(taskTypeElement),
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
              tabs: [Text("To Do"), Text("In Progress"), Text("Done")],
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
                      readToDoTasksFromJSONtaskSaveFile().then((Map<String, dynamic> value) {
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

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String taskTitle = "New Task";
  String taskType = taskTypeCatergories.first;
  Map<String, bool> criteriasFilledIn = {"title": false, "taskType": true, "priority": false};
  Map<String, dynamic> newTaskData = {"title": "", "description": "", "taskType": "", "priority": "", "subtasks": []};
  Map<String, dynamic> newSubTaskData = {"title": "", "description": "", "completed": false};

  bool checkIfAllCriteriaIsFilledIn(criteriaList) {
    bool allCriteriaFilledIn = true;
    for (var item in criteriaList.values) {
      if (item == false) {
        allCriteriaFilledIn = false;
      }
    }
    return allCriteriaFilledIn;
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        newTaskData["priority"] = "none";
                        criteriasFilledIn["priority"] = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: newTaskData["priority"] == "none" ? RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(5)) : null,
                    ),
                    child: const Text("None"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        newTaskData["priority"] = "low";
                        criteriasFilledIn["priority"] = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: newTaskData["priority"] == "low" ? RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(5)) : null,
                    ),
                    child: const Text("Low"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        newTaskData["priority"] = "medium";
                        criteriasFilledIn["priority"] = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: newTaskData["priority"] == "medium" ? RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(5)) : null,
                    ),
                    child: const Text("Medium"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        newTaskData["priority"] = "high";
                        criteriasFilledIn["priority"] = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: newTaskData["priority"] == "high" ? RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(5)) : null,
                    ),
                    child: const Text("High"),
                  ),
                ),
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
                showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        title: AppLayout.colorAdaptivText("add a subtask"),
                        backgroundColor: colorScheme.background,
                        content: Stack(
                          children: [
                            Form(
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      enabledBorder: AppLayout.inactiveBorder(),
                                      focusedBorder: AppLayout.activeBorder(),
                                      hintText: "Title for sub-task",
                                      hintStyle: TextStyle(color: colorScheme.text),
                                    ),
                                    style: TextStyle(color: colorScheme.text),
                                    cursorColor: colorScheme.primary,
                                    onChanged: (value) => setState(() {
                                      newSubTaskData["title"] = value;
                                    }),
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      enabledBorder: AppLayout.inactiveBorder(),
                                      focusedBorder: AppLayout.activeBorder(),
                                      hintText: "Description for sub-task",
                                      hintStyle: TextStyle(color: colorScheme.text),
                                    ),
                                    style: TextStyle(color: colorScheme.text),
                                    cursorColor: colorScheme.primary,
                                    onChanged: (value) => newSubTaskData["description"] = value,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (newSubTaskData["title"] != "") {
                                        setState(() {
                                          newTaskData["subtasks"].add(Map<String, dynamic>.from(newSubTaskData));
                                          newSubTaskData["title"] = "";
                                          newSubTaskData["description"] = "";
                                        });
                                      }
                                      ;
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: newSubTaskData["title"] != "" ? Colors.green : Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                    ),
                                    label: const Text("Add sub-task"),
                                    icon: const Icon(Icons.add),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newTaskData["subtasks"].length,
              itemBuilder: (context, index) {
                Map<String, dynamic> subtask = newTaskData["subtasks"][index];
                return Card(
                  color: colorScheme.card,
                  elevation: 2,
                  child: ListTile(
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
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (checkIfAllCriteriaIsFilledIn(criteriasFilledIn)) {
            setState(() {
              toDoTasks["toDo"].add(newTaskData);
              writeToJSONtaskSaveFile(toDoTasks);
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

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  void applyNewColor(color) {
    setState(() {
      colorScheme.setPrimary(color);
      accentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          // TODO laat het werken voor telefoon back button
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Settings"),
        backgroundColor: colorScheme.primary,
      ),
      body: ListView(
        children: [
          ///
          /// app accent color
          ///
          _settingsCard(
            title: DropdownButton(
              dropdownColor: Colors.grey[700],
              value: null,
              hint: AppLayout.colorAdaptivText("Accent Color: $accentColor"),
              items: colorSchemeChoice.map(
                (String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) => applyNewColor(value),
            ),
          ),

          ///
          /// show programming color
          ///
          _settingsCard(
            title: _settingsCardTitle("Show Programming Color"),
            leading: Switch(
              value: showProgrammingColor,
              activeColor: colorScheme.primary,
              onChanged: (value) => setState(() {
                showProgrammingColor = value;
              }),
            ),
          ),

          ///
          /// dark mode
          ///
          _settingsCard(
            title: _settingsCardTitle("Dark Mode"),
            leading: Switch(
              value: darkMode,
              activeColor: colorScheme.primary,
              onChanged: (value) => setState(() {
                colorScheme.switchLightDarkMode();
                darkMode = value;
              }),
            ),
          ),
          _settingsCard(
              title: _settingsCardTitle("Only Search In Title"),
              leading: Switch(
                value: onlySearchInTitle,
                activeColor: colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    onlySearchInTitle = !onlySearchInTitle;
                  });
                },
              ))
        ],
      ),
    );
  }
}

Widget _settingsCard({dynamic leading, dynamic title}) {
  return Card(
    color: colorScheme.card,
    elevation: 2,
    child: ListTile(
      title: title,
      leading: leading,
    ),
  );
}

Widget _settingsCardTitle(String title) {
  return AppLayout.colorAdaptivText(title);
}

// TODO add screen for detailed info of task
