import 'package:flutter/material.dart';

typedef MoveCallback = void Function(int value);

class TaskMoveController extends StatelessWidget {
  final String currentTab;
  final MoveCallback onClicked;
  const TaskMoveController({required this.currentTab, required this.onClicked, super.key});

  @override
  Widget build(BuildContext context) {
    if (currentTab == "toDo") {
      return _MoveToInProgress(
        icon: const Icon(Icons.arrow_back),
        onClicked: (value) => value,
      );
    } else if (currentTab == "inProgress") {
      return _MoveToToDo(
        icon: const Icon(Icons.arrow_forward),
        onClicked: (value) => value,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _MoveToToDo(
              icon: const Icon(Icons.arrow_back),
              onClicked: (value) => value,
            ),
          ),
          Expanded(
            child: _MoveToInProgress(
              icon: const Icon(Icons.arrow_back),
              onClicked: (value) => value,
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
  const _MoveToToDo({required this.icon, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onClicked(0),
      icon: icon,
      label: const Text("Move To 'To-Do')"),
    );
  }
}

class _MoveToInProgress extends StatelessWidget {
  final MoveButtonCallback onClicked;
  final Icon icon;
  const _MoveToInProgress({required this.icon, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onClicked(1),
      icon: icon,
      label: const Text("Move To 'In Progress'"),
    );
  }
}
