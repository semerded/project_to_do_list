import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/enums.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/priority_border.dart';

typedef ButtonCallback = void Function(int value);
typedef ValueCallback = void Function(bool value);

class SingleClickPriorityButton extends StatefulWidget {
  final ButtonCallback buttonCallback;
  final int currentPriority;
  const SingleClickPriorityButton({required this.currentPriority, required this.buttonCallback, super.key});

  @override
  State<SingleClickPriorityButton> createState() => _SingleClickPriorityButtonState();
}

class _SingleClickPriorityButtonState extends State<SingleClickPriorityButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _PriorityButton(
            currentPriority: widget.currentPriority,
            priority: Priority.none,
            onClicked: (value) {
              if (value) {
                widget.buttonCallback(Priority.none.index);
              }
            },
          ),
          _PriorityButton(
            currentPriority: widget.currentPriority,
            priority: Priority.low,
            onClicked: (value) {
              if (value) {
                widget.buttonCallback(Priority.low.index);
              }
            },
          ),
          _PriorityButton(
            currentPriority: widget.currentPriority,
            priority: Priority.medium,
            onClicked: (value) {
              if (value) {
                widget.buttonCallback(Priority.medium.index);
              }
            },
          ),
          _PriorityButton(
            currentPriority: widget.currentPriority,
            priority: Priority.high,
            onClicked: (value) {
              if (value) {
                widget.buttonCallback(Priority.high.index);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _PriorityButton extends StatefulWidget {
  final ValueCallback onClicked;
  final Priority priority;
  final int currentPriority;

  const _PriorityButton({required this.priority, required this.currentPriority, required this.onClicked, super.key});

  @override
  State<_PriorityButton> createState() => _PriorityButtonState();
}

class _PriorityButtonState extends State<_PriorityButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => widget.onClicked(true),
        style: ElevatedButton.styleFrom(
          backgroundColor: taskPriorityColors[widget.priority.index],
          shape: widget.currentPriority == widget.priority.index ? priorityBorder() : null,
        ),
        child: Text(widget.priority.name),
      ),
    );
  }
}
