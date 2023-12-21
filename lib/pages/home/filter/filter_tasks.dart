import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';

bool checkIfTaskIsNotFilteredOut(Map taskData, filteredTasksBySearch, filterTaskByPriority) {
  bool taskIsNotFilteredOut = true;
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
    if (!filterTaskByPriority[taskData["priority"]]) {
      taskIsNotFilteredOut = false;
    }
    return taskIsNotFilteredOut;
  }

class FilterTaskTypeButton extends StatefulWidget {
  const FilterTaskTypeButton({super.key});

  @override
  State<FilterTaskTypeButton> createState() => _FilterTaskTypeButtonState();
}

class _FilterTaskTypeButtonState extends State<FilterTaskTypeButton> {
  @override
  Widget build(BuildContext context) {
   
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
              backgroundColor: taskTypeCatergoriesColors[taskTypeElement][0],
              shape: taskTypesActive[taskTypeElement]
                  ? RoundedRectangleBorder(
                      side: BorderSide(width: 5, color: colorScheme.text),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    )
                  : null),
          child: Text(
            taskTypeElement,
            style: TextStyle(color: taskTypeCatergoriesColors[taskTypeElement][1] ? Colors.black : Colors.white),
          ),
        );
      },
    );
  }
  }

  