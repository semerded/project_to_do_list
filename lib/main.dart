import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String jsonFilePath = "assets/toDoSaveFile.json";
const JsonDecoder decoder = JsonDecoder();
List<dynamic> saveFileData = [];
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

Future<void> readJson() async {
  final String jsonString = await rootBundle.loadString(jsonFilePath);
  saveFileData = jsonDecode(jsonString);
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
    readJson();
  }

  List<String> filterLanguage = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
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
                    MaterialPageRoute(builder: (context) => const SettingsMenu()),
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
                itemCount: saveFileData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> indexData = saveFileData[index];
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
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                        child: const Text("Python"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text("HTML"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text("Java"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                        child: const Text("Flutter"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                        child: const Text("C++"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        child: const Text("Arduino"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[900]),
                        child: const Text("Kotlin"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text("My Website"),
                      ),
                      ElevatedButton(
                        onPressed: () => null,
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
          const Text("Title of task"),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
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
                setState(() {
                  if (value != "") {
                    taskTitle = value;
                  } else {
                    taskTitle = "New Task";
                  }
                });
              },
            ),
          ),
          const Text("Description of task"),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: AppLayout.inactiveBorder(),
                focusedBorder: AppLayout.activeBorder(),
                hintText: "A description for your project",
                hintStyle: TextStyle(color: colorScheme.text),
              ),
              style: TextStyle(color: colorScheme.text),
              cursorColor: colorScheme.primary,
              onChanged: (value) {},
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("None"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Low"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: const Text("Medium"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("High"),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.grey[700],
            child: DropdownButton(
              dropdownColor: Colors.grey[700],
              value: programmingLanguage,
              isExpanded: true,
              borderRadius: BorderRadius.circular(10),
              items: programmingLanguagesChoice.map(
                (String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) {
                setState(() {
                  programmingLanguage = value!;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
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
