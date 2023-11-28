import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String jsonFilePath = "assets/toDoSaveFile.json";
List<dynamic> toDoTasks = [];
List<String> colorSchemeChoice = ['Green', 'Red', 'Blue', 'Orange', 'Purple'];
Map<String, MaterialColor> colorSchemeReference = {'Green': Colors.green, 'Red': Colors.red, 'Blue': Colors.blue, 'Orange': Colors.orange, 'Purple': Colors.purple};

List<String> programmingLanguagesChoice = ['Real Life', 'Python', 'HTML', 'Java', 'Flutter', 'C++', 'Arduino', 'Kotlin', 'My Website', 'Other'];

Map<String, dynamic> userPresets = {"colorSchemeChoice": "Orange", "showProgrammingColor": true, "darkMode": true, "onlySearchInTitle": false};

String accentColor = userPresets["colorSchemeChoice"]; // TODO make json with app settings and add save color scheme in there
bool showProgrammingColor = userPresets["showProgrammingColor"];
bool darkMode = userPresets["darkMode"];
bool onlySearchInTitle = userPresets["onlySearchInTitle"];
// TODO maak json map

// test() {
//   return  Colors.white;
// }

Future<List<dynamic>> readJson() async {
  final String jsonString = await rootBundle.loadString(jsonFilePath);
  return jsonDecode(jsonString);
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

class _APPState extends State<APP> {
  @override
  void initState() {
    super.initState();
    readJson().then((List<dynamic> value) {
      setState(() {
        toDoTasks = value;
      });
    });
  }

  List<String> filterLanguage = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        animationDuration: const Duration(milliseconds: 300),
        length: 2,
        child: Scaffold(
          backgroundColor: colorScheme.background,
          appBar: AppBar(
            backgroundColor: colorScheme.primary,
            title: const Center(
              child: Text("The Project To Do List"),
            ),
            bottom: const TabBar(
              tabs: [Text("In Progress"), Text("Done")],
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
          body: TabBarView(
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
                  onChanged: (value) {},
                ),
              ),
              ListView.builder(
                itemCount: toDoTasks.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> indexData = toDoTasks[index];
                  return Card(
                    color: colorScheme.card,
                    elevation: 2,
                    child: ListTile(
                      textColor: colorScheme.text,
                      leading: Text(indexData["priority"].toString()),
                      title: Text(indexData["title"].toString()),
                      subtitle: Text(indexData["description"]),
                      trailing: Text(indexData["language"].toString()),
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
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
                child: Icon(Icons.cancel_outlined),
              ),
              Expanded(
                                child: SizedBox(
                  height: 30,
      
                  child: ListView(
                    

                    scrollDirection: Axis.horizontal,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() {
                          filterLanguage[1];
                        }),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                        child: const Text("Real Life"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                        child: const Text("Python"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text("HTML"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Java"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                        child: const Text("Flutter"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        child: const Text("C++"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        child: const Text("Arduino"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[900]),
                        child: const Text("Kotlin"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("My Website"),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        child: const Text(
                          "Other",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
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
  String programmingLanguage = programmingLanguagesChoice.first;
  Map<String, bool> criteriasFilledIn = {"title": false, "language": true, "priority": false};
  Map<String, String> newTaskData = {"title": "", "description": "", "language": "", "priority": ""};

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
            child: Text(
              "Title of task",
              style: TextStyle(color: colorScheme.text),
            ),
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
          Text(
            "Description of task",
            style: TextStyle(color: colorScheme.text),
          ),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: newTaskData["priority"] == "low" ? RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(5)) : null,),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, shape: newTaskData["priority"] == "medium" ? RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(5)) : null,),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: newTaskData["priority"] == "high" ? RoundedRectangleBorder(side: const BorderSide(width: 3, color: Colors.white), borderRadius: BorderRadius.circular(5)) : null,),
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
              hint: Text("selected language: $programmingLanguage"),
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.keyboard_arrow_down),
              padding: const EdgeInsets.all(10),
              items: programmingLanguagesChoice.map(
                (String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: (value) {
                newTaskData["language"] = value!;
                setState(() {
                  programmingLanguage = value;
                  criteriasFilledIn["language"] = true;
                });
              },
            ),
          ),
          Text("hello")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
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
              hint: Text("Accent Color: $accentColor"),
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
                onChanged: (value) => setState(() {
                  onlySearchInTitle = !onlySearchInTitle;
                }),
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
  return Text(
    title,
    style: TextStyle(color: colorScheme.text),
  );
}

// TODO add screen for detailed info of task