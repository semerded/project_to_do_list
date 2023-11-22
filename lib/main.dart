import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String jsonFilePath = "assets/toDoSaveFile.json";
const JsonDecoder decoder = JsonDecoder();
List<dynamic> saveFileData = [];
List<String> colorSchemeChoice = ['Green', 'Red', 'Blue', 'Orange', 'Purple'];

Map<String, dynamic> userPresets = {"colorSchemeChoice": "Orange", "showProgrammingColor": true};

// TODO maak json map

Future<void> readJson() async {
  final String jsonString = await rootBundle.loadString(jsonFilePath);
  saveFileData = jsonDecode(jsonString);
}

void main() {
  runApp(const APPtheme());
}

class APPtheme extends StatelessWidget {
  const APPtheme({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TO DO LIST",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark, background: Colors.grey[900], primary: Colors.orange, secondary: Colors.orange),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.orange),
        brightness: Brightness.dark,
      ),
      home: const APP(),
    );
  }
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
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
              ListView.builder(
                itemCount: saveFileData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> indexData = saveFileData[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
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
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Add $taskTitle"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(children: [
        const Text("Title of task"),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: TextField(
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "A title for your project"),
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
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "A description for your project"),
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
            )
          ],
        )
      ]),
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
  @override
  String defaultDropdownChoice = userPresets["colorSchemeChoice"]; // TODO make json with app settings and add save color scheme in there
  bool showProgrammingColor = userPresets["showProgrammingColor"];
  void applyNewColor(color) {}
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: GridView.count( // TODO make grid
        crossAxisCount: 2,
        
        
        children: [
          //
          // app accent color
          DropdownButton(
            value: defaultDropdownChoice,
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
          const Text("App Accent Color"),
          //
          // show programming color
          Switch(
            value: showProgrammingColor,
            onChanged: (value) => setState(() {
              showProgrammingColor = value;
            }),
          ),
          const Text("Show Programming Color")
        ],
      ),
    );
  }
}
