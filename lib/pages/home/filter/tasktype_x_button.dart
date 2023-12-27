Map hideShowAllTaskTypes(filterTaskByTaskType) {


    if (checkIfAllTaskTypesAreEnabled(filterTaskByTaskType)) {
      return disableAllTaskTypes(filterTaskByTaskType);
    } else {
      return enableAllTaskTypes(filterTaskByTaskType);
    }
  }

  bool checkIfAllTaskTypesAreEnabled(filterTaskByTaskType) {
    bool allTaskTypesEnabled = true;
    for (bool value in filterTaskByTaskType.values) {
      if (!value) {
        allTaskTypesEnabled = false;
      }
    }
    return allTaskTypesEnabled;
  }

  Map disableAllTaskTypes(filterTaskByTaskType) {
    for (String taskType in filterTaskByTaskType.keys) {
      filterTaskByTaskType[taskType] = false;
    }
    return filterTaskByTaskType;
  }

  Map enableAllTaskTypes(filterTaskByTaskType) {
    for (String taskType in filterTaskByTaskType!.keys) {
      filterTaskByTaskType[taskType] = true;
    }
    return filterTaskByTaskType;
  }

