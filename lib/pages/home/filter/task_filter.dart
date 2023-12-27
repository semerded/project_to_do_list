import 'package:project_to_do_list/components/globals.dart';


bool checkIfTaskIsNotFilteredOut(Map taskData, filteredTasksBySearch, filterTasksByPriority, filteredTasksByTaskType) {
  bool taskIsNotFilteredOut = true;

  // check if task is filtered by search bar
  if (!taskData["title"].contains(filteredTasksBySearch)) {
    taskIsNotFilteredOut = false;
  }
  if (!onlySearchInTitle && !taskData["description"].contains(filteredTasksBySearch)) {
    taskIsNotFilteredOut = false;
  }
  if (searchInSubTasks) {
    for (var subTask in taskData["subtasks"]) {
      if (!subTask["title"].contains(filteredTasksBySearch)) {
        taskIsNotFilteredOut = false;
      }
    }
  }

  // check if task is filtered by priority
  if (!filterTasksByPriority[taskData["priority"]]) {
    taskIsNotFilteredOut = false;
  }

  // check if task is filtered by task type
  if (taskTypeCatergories.contains(taskData["taskType"])) {
    if (!filteredTasksByTaskType[taskData["taskType"]]) {
        taskIsNotFilteredOut = false;
    }
  } else {
    if (!filteredTasksByTaskType["Other"]) {
      taskIsNotFilteredOut = false;
    }
  
  }
 
  return taskIsNotFilteredOut;
}