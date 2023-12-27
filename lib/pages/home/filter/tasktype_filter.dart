import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';

typedef TaskTypeFilterCallback = void Function(Map value);

class FilterTaskTypeButton extends StatefulWidget {
  final TaskTypeFilterCallback onChanged;
  final Map filterTaskByTasktype;
  const FilterTaskTypeButton({required this.filterTaskByTasktype, required this.onChanged, super.key});

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
          onPressed: () {
            widget.filterTaskByTasktype[taskTypeElement] = !widget.filterTaskByTasktype[taskTypeElement];
            widget.onChanged(widget.filterTaskByTasktype);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: taskTypeCatergoriesColors[taskTypeElement][0],
              shape: widget.filterTaskByTasktype[taskTypeElement]
                  ? RoundedRectangleBorder(
                      side: BorderSide(width: 5, color: colorScheme.text),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    )
                  : const RoundedRectangleBorder()),
          child: Text(
            taskTypeElement,
            style: TextStyle(color: taskTypeCatergoriesColors[taskTypeElement][1] ? Colors.black : Colors.white),
          ),
        );
      },
    );
  }
}
