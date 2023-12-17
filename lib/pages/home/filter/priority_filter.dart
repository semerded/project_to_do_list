import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/enums.dart';
import 'package:project_to_do_list/components/globals.dart';

typedef MyCallback = void Function(bool value);

class PriorityButton extends StatefulWidget {
  final List filterTaskByPriority;

  const PriorityButton({required this.filterTaskByPriority, super.key});

  @override
  State<PriorityButton> createState() => _PriorityButtonState();
}

class _PriorityButtonState extends State<PriorityButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PriorityButton(
          priority: Priority.none,
          filterTaskByPriority: widget.filterTaskByPriority,
          onClicked: (value) => setState(() {
             widget.filterTaskByPriority[Priority.none.index] = value;
          }),
        ),
        _PriorityButton(
          priority: Priority.low,
          filterTaskByPriority: widget.filterTaskByPriority,
          onClicked: (value) => setState(() {
            widget.filterTaskByPriority[Priority.low.index] = value;
          }),
        ),
        _PriorityButton(
          priority: Priority.medium,
          filterTaskByPriority: widget.filterTaskByPriority,
          onClicked: (value) => setState(() {
            widget.filterTaskByPriority[Priority.medium.index] = value;
          }),
        ),
        _PriorityButton(
          priority: Priority.high,
          filterTaskByPriority: widget.filterTaskByPriority,
          onClicked: (value) => setState(() {
            widget.filterTaskByPriority[Priority.high.index] = value;
          }),
        )
      ],
    );
  }
}

class _PriorityButton extends StatefulWidget {
  final MyCallback onClicked;
  final Priority priority;
  final List filterTaskByPriority;

  const _PriorityButton({required this.priority, required this.filterTaskByPriority, required this.onClicked, super.key});

  @override
  State<_PriorityButton> createState() => PriorityButtonState();
}

class PriorityButtonState extends State<_PriorityButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() {
          widget.onClicked(!widget.filterTaskByPriority[widget.priority.index]);
        }),
        style: ElevatedButton.styleFrom(
          backgroundColor: taskPriorityColors[widget.priority.index],
          shape: widget.filterTaskByPriority[widget.priority.index] == true ? priorityBorder() : null,
        ),
        child: Text(widget.priority.name),
      ),
    );
  }
}

RoundedRectangleBorder priorityBorder() {
  return RoundedRectangleBorder(
    side: const BorderSide(width: 3, color: Colors.white),
    borderRadius: BorderRadius.circular(5),
  );
}
