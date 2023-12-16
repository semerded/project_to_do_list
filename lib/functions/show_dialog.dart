import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/enums.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';

Future subTaskDialog(context) {
  Map newSubTaskData = {"title": "", "description": "", "completed": false, "priority": Priority.none.index};
  BorderSide priorityBorder = BorderSide(color: colorScheme.text, width: 3);

  return showDialog(
    context: context,
    builder: ((context) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: AppLayout.colorAdaptivText("add a subtask"),
              backgroundColor: colorScheme.background,
              content: Stack(
                children: [
                  Form(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            enabledBorder: AppLayout.inactiveBorder(),
                            focusedBorder: AppLayout.activeBorder(),
                            hintText: "Title for sub-task",
                            hintStyle: TextStyle(color: colorScheme.text),
                          ),
                          style: TextStyle(color: colorScheme.text),
                          cursorColor: colorScheme.primary,
                          onChanged: (value) => setState(() {
                            newSubTaskData["title"] = value;
                          }),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            enabledBorder: AppLayout.inactiveBorder(),
                            focusedBorder: AppLayout.activeBorder(),
                            hintText: "Description for sub-task",
                            hintStyle: TextStyle(color: colorScheme.text),
                          ),
                          style: TextStyle(color: colorScheme.text),
                          cursorColor: colorScheme.primary,
                          onChanged: (value) => newSubTaskData["description"] = value,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => setState(() {
                                  newSubTaskData["priority"] = Priority.none.index;
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: CircleBorder(
                                    side: newSubTaskData["priority"] == Priority.none.index ? priorityBorder : const BorderSide(),
                                  ),
                                ),
                                child: null,
                              ),
                              ElevatedButton(
                                onPressed: () => setState(() {
                                  newSubTaskData["priority"] = Priority.low.index;
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: CircleBorder(
                                    side: newSubTaskData["priority"] == Priority.low.index ? priorityBorder : const BorderSide(),
                                  ),
                                ),
                                child: null,
                              ),
                              ElevatedButton(
                                onPressed: () => setState(() {
                                  newSubTaskData["priority"] = Priority.medium.index;
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  shape: CircleBorder(
                                    side: newSubTaskData["priority"] == Priority.medium.index ? priorityBorder : const BorderSide(),
                                  ),
                                ),
                                child: null,
                              ),
                              ElevatedButton(
                                onPressed: () => setState(() {
                                  newSubTaskData["priority"] = Priority.high.index;
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: CircleBorder(
                                    side: newSubTaskData["priority"] == Priority.high.index ? priorityBorder : const BorderSide(),
                                  ),
                                ),
                                child: null,
                              )
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (newSubTaskData["title"] != "") {
                              setState(() {
                                Navigator.of(context, rootNavigator: true).pop(newSubTaskData);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: newSubTaskData["title"] != "" ? Colors.green : Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          label: const Text("Add sub-task"),
                          icon: const Icon(Icons.add),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        )),
  );
}