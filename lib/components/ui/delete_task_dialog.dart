import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';

Future deleteTaskDialog(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete task forever?"),
      content: const Text("This is irreversable!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: AppLayout.colorAdaptivText("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            "Delete forever",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
      backgroundColor: colorScheme.background,
      titleTextStyle: TextStyle(
        color: colorScheme.primary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(color: colorScheme.text),
    ),
  );
}
