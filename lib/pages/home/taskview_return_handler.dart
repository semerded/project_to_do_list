class TaskViewReturnHandler {
  dynamic returnValue;
  Map? taskList;
  String? currentTab;
  int? index;

  TaskViewReturnHandler(this.returnValue, this.taskList, this.currentTab, this.index);


  Map returnUpdatedToDoTaskList() {
    if (returnValue != null) {
      print("$taskList | $currentTab | $index");
      String command = returnValue[0];
      dynamic value = returnValue[1];
      return commandHandler(command, value);
    } else {
      print("value was null");
      return taskList!;
    }
  }

  Map commandHandler(String command, dynamic value) {
    Map commandLinkedWithFunction = {"delete": _delete, "complete": _completeTask, "save": _save, "discard": _discard};

    if (commandLinkedWithFunction.containsKey(command)) {
      return commandLinkedWithFunction[command](value);
    } else {
      return taskList!;
    }
  }

  Map _delete(value) {
    return taskList![currentTab].removeAt(index);
  }

  Map _completeTask(value) {
    taskList!["completed"].add(value);
    return taskList![currentTab].removeAt(index);
  }

  Map _save(value) {
    return taskList![currentTab][index] = value;
  }

  Map _discard(value) {
    return _save(value);
  }

  Map _archive(value) {
    // TODO make an archive and add task to it
    return taskList![currentTab].removeAt(index);
  }
}
