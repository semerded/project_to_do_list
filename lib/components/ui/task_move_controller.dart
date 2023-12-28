import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/enums.dart';

typedef MoveCallback = void Function(ReturnCommand value);

class TaskMoveController extends StatelessWidget {
  final String currentTab;
  final MoveCallback onClicked;

  const TaskMoveController({required this.currentTab, required this.onClicked, super.key});

  @override
  Widget build(BuildContext context) {
    if (currentTab == "toDo") {
      return _MoveToInProgress(
        icon: const Icon(Icons.arrow_forward),
        color: Colors.green[200],
        onClicked: (value) => onClicked(ReturnCommand.moveToInProgress),
      );
    } else if (currentTab == "inProgress") {
      return _MoveToToDo(
        icon: const Icon(Icons.arrow_back),
        color: Colors.red[400],
        onClicked: (value) => onClicked(ReturnCommand.moveToToDo),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _MoveToToDo(
              icon: const Icon(Icons.arrow_back),
              color: Colors.red[400],
              onClicked: (value) => onClicked(ReturnCommand.moveToToDo),
            ),
          ),
          Expanded(
            child: _MoveToInProgress(
              icon: const Icon(Icons.arrow_back),
              color: Colors.red[400],
              onClicked: (value) => onClicked(ReturnCommand.moveToInProgress),
            ),
          ),
        ],
      );
    }
  }
}

typedef MoveButtonCallback = void Function(int value);

class _MoveToToDo extends StatelessWidget {
  final MoveButtonCallback onClicked;
  final Icon icon;
  final dynamic color;
  const _MoveToToDo({required this.icon, required this.color, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onClicked(0),
      icon: icon,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
      ),
      label: const Text("Move To 'To-Do'"),
    );
  }
}

class _MoveToInProgress extends StatelessWidget {
  final MoveButtonCallback onClicked;
  final Icon icon;
  final dynamic color;
  const _MoveToInProgress({required this.icon, required this.color, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onClicked(1),
      icon: icon,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
      ),
      label: const Text("Move To 'In Progress'"),
    );
  }
}
