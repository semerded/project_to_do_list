import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';

Widget dividingLine(color, {double height = 10}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Container(height: height, color: color),
  );
}

String checkIfTaskTypeIsValid(taskTypeOfTask) {
  if (taskTypeCatergories.contains(taskTypeOfTask)) {
    return taskTypeOfTask;
  }
  return "Other";
}

double getTaskCompletion(List<dynamic> subtaskList) {
  if (subtaskList.isEmpty) {
    return 0.0;
  }
  double completedTaskCounter = 0;
  for (Map subTask in subtaskList) {
    if (subTask["completed"]) {
      completedTaskCounter++;
    }
  }
  return completedTaskCounter;
}

bool checkIfAllCriteriaIsFilledIn(criteriaList) {
    bool allCriteriaFilledIn = true;
    for (var item in criteriaList.values) {
      if (item == false) {
        allCriteriaFilledIn = false;
      }
    }
    return allCriteriaFilledIn;
  }


