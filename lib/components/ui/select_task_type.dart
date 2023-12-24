import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';

typedef TaskTypeCallback = void Function(String value);

class SelectTaskType extends StatefulWidget {
  final TaskTypeCallback taskTypeCallback;
  final String currentTaskType;
  const SelectTaskType({required this.currentTaskType, required this.taskTypeCallback, super.key});

  @override
  State<SelectTaskType> createState() => _SelectTaskTypeState();
}

class _SelectTaskTypeState extends State<SelectTaskType> {
  String taskType = "";

  @override
  void initState() {
    super.initState();
    taskType = widget.currentTaskType;
    if (!taskTypeCatergories.contains(taskType)) {
      taskType = "Other";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 5,
          color: taskTypeCatergoriesColors[taskType][0],
        ),
      ),
      child: DropdownButton(
          dropdownColor: colorScheme.card,
          isExpanded: true,
          hint: AppLayout.colorAdaptivText("selected task type: $taskType"),
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.keyboard_arrow_down),
          padding: const EdgeInsets.all(10),
          items: taskTypeCatergories.map(
            (String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: taskTypeCatergoriesColors[value][0],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) => setState(() {
                taskType = value!;
                widget.taskTypeCallback(value);
              })),
    );
  }
}
