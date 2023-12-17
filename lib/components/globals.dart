import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/color_scheme.dart';
import 'package:project_to_do_list/components/enums.dart';

const String jsonFilePath = "assets/toDoSaveFile.json";

Map toDoTasks = {};
List<String> colorSchemeChoice = ['Green', 'Red', 'Blue', 'Orange', 'Purple'];
Map<String, MaterialColor> colorSchemeReference = {'Green': Colors.green, 'Red': Colors.red, 'Blue': Colors.blue, 'Orange': Colors.orange, 'Purple': Colors.purple};

List<String> taskTypeCatergories = ['Real Life', 'Python', 'HTML', 'Java', 'Flutter', 'C++', 'Arduino', 'JavaScript', 'Kotlin', 'My Website', 'Other'];
Map taskTypeCatergoriesColors = {
  taskTypeCatergories[0]: [Colors.grey, true],
  taskTypeCatergories[1]: [Colors.lightBlue, false],
  taskTypeCatergories[2]: [Colors.orange, false],
  taskTypeCatergories[3]: [Colors.red, false],
  taskTypeCatergories[4]: [Colors.blue[600], false],
  taskTypeCatergories[5]: [Colors.purple, false],
  taskTypeCatergories[6]: [Colors.teal, false],
  taskTypeCatergories[7]: [Colors.yellow, true],
  taskTypeCatergories[8]: [Colors.green[900], false],
  taskTypeCatergories[9]: [Colors.green, false],
  taskTypeCatergories[10]: [Colors.black, false]
};
Map taskTypesActive = {
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

Map taskPriorityColors = {Priority.none.index: Colors.grey, Priority.low.index: Colors.green, Priority.medium.index: Colors.yellow, Priority.high.index: Colors.red};

Map userPresets = {"colorSchemeChoice": "Orange", "showProgrammingColor": true, "darkMode": true, "onlySearchInTitle": false, "searchInSubTasks": false};

String accentColor = userPresets["colorSchemeChoice"]; // TODO make json with app settings and add save color scheme in there
bool showProgrammingColor = userPresets["showProgrammingColor"];
bool darkMode = userPresets["darkMode"];
bool onlySearchInTitle = userPresets["onlySearchInTitle"];
bool searchInSubTasks = userPresets["searchInSubTasks"];

APPcolorScheme colorScheme = APPcolorScheme();