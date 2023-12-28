import 'package:project_to_do_list/components/enums.dart';

class TaskViewReturnHandler {
  dynamic returnValue;
  Map? taskList;
  String? currentTab;
  int? index;

  TaskViewReturnHandler(this.returnValue, this.taskList, this.currentTab, this.index);

  Map returnUpdatedToDoTaskList() {
    if (returnValue != null) {
      ReturnCommand command = returnValue[0];
      dynamic value = returnValue[1];
      return commandHandler(command, value);
    } else {
      return taskList!;
    }
  }

  Map commandHandler(ReturnCommand command, dynamic value) {
    Map commandLinkedWithFunction = {
      ReturnCommand.save: _save,
      ReturnCommand.discard: _discard,
      ReturnCommand.delete: _delete,
      ReturnCommand.moveToToDo: _moveToToDo,
      ReturnCommand.moveToInProgress: _moveToInProgress,
      ReturnCommand.moveToComplete: _completeTask,
      ReturnCommand.archive: _archive,
    };

    if (commandLinkedWithFunction.containsKey(command)) {
      return commandLinkedWithFunction[command](value);
    } else {
      return taskList!;
    }
  }

  Map _delete(value) {
    return taskList![currentTab].removeAt(index);
  }

  Map _moveTo(value, String tabToMoveTo) {
    taskList![tabToMoveTo].add(value);
    print(tabToMoveTo);
    return taskList![currentTab].removeAt(index);
  }

  Map _completeTask(value) {
    return _moveTo(value, "completed");
  }

  Map _moveToInProgress(value) {
    return _moveTo(value, "inProgress");
  }

  Map _moveToToDo(value) {
    return _moveTo(value, "toDo");
  }

  Map _save(value) {
    return taskList![currentTab][index] = value;
  }

  Map _discard(value) {
    /// saves the unchanged copy of the task
    return _save(value);
  }

  Map _archive(value) {
    // TODO make an archive and add task to it
    return taskList![currentTab].removeAt(index);
  }
}
