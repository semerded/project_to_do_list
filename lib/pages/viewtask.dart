import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:deepcopy/deepcopy.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/functions/global_functions.dart';
import 'package:project_to_do_list/components/ui/show_subtask_dialog.dart';


class ShowTaskScreen extends StatefulWidget {
  final Map toDoTaskPerIndex;
  final String currentTab;
  final int index;
  const ShowTaskScreen({super.key, required this.toDoTaskPerIndex, required this.currentTab, required this.index});

  @override
  State<ShowTaskScreen> createState() => _ShowTaskScreenState();
}

class _ShowTaskScreenState extends State<ShowTaskScreen> {
  Map unchangedCopyOfCurrentTask = {}; //  not possible with deepcopy

  bool isTaskChanged() {
    if (const DeepCollectionEquality().equals(unchangedCopyOfCurrentTask, widget.toDoTaskPerIndex)) {
      return false; // false because task has not changed
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    unchangedCopyOfCurrentTask = widget.toDoTaskPerIndex.deepcopy();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          title: Text(
            widget.toDoTaskPerIndex["title"],
            overflow: TextOverflow.ellipsis,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop([false, unchangedCopyOfCurrentTask]),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(null),
              icon: const Icon(Icons.delete_forever),
            )
          ],
        ),
        body: ListView(
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 30,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16, elevation: 5),
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.grey[600],
                thumbColor: colorScheme.primary,
              ),
              child: AbsorbPointer(
                child: Slider(
                  value: getTaskCompletion(widget.toDoTaskPerIndex["subtasks"]),
                  min: 0,
                  max: widget.toDoTaskPerIndex["subtasks"].length.toDouble(),
                  onChanged: (value) => value,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: AppLayout.primaryText(widget.toDoTaskPerIndex["title"], fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            dividingLine(colorScheme.primary),
            Padding(
              padding: const EdgeInsets.all(8),
              child: AppLayout.colorAdaptivText(widget.toDoTaskPerIndex["description"], fontSize: 18),
            ),
    
            ///////////////////////
            // subtask displayer //
            ///////////////////////
            Column(
              children: [
                Card(
                  elevation: 2,
                  shape: AppLayout.cardBorder(borderRadius: 20, borderColor: colorScheme.primary, borderWidth: 3),
                  color: colorScheme.card,
                  child: ListTile(
                    leading: Icon(
                      Icons.add,
                      color: colorScheme.text,
                    ),
                    title: AppLayout.colorAdaptivText("add subtask"),
                    onTap: () {
                      subTaskDialog(context).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.toDoTaskPerIndex["subtasks"].add(value);
                          });
                        }
                      });
                    },
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.toDoTaskPerIndex["subtasks"].length,
                  itemBuilder: (context, subIndex) {
                    Map subTask = widget.toDoTaskPerIndex["subtasks"][subIndex];
                    bool subTaskCompleted = subTask["completed"];
                    return Card(
                      color: colorScheme.card,
                      elevation: 2,
                      child: ListTile(
                        onTap: () => setState(() {
                          subTaskCompleted = !subTaskCompleted;
                          widget.toDoTaskPerIndex["subtasks"][subIndex]["completed"] = subTaskCompleted;
                        }),
                        title: AppLayout.colorAdaptivText(subTask["title"]),
                        subtitle: AppLayout.colorAdaptivText(subTask["description"]),
                        shape: subTaskCompleted ? const RoundedRectangleBorder(side: BorderSide(width: 2, color: Colors.green), borderRadius: BorderRadius.all(Radius.circular(5))) : null,
                       trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.toDoTaskPerIndex["subtasks"].removeAt(subIndex);
                              });
                            },
                            icon: const Icon(Icons.delete_forever)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // discard changes
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop([false, unchangedCopyOfCurrentTask]);
                },
                icon: const Icon(Icons.arrow_back),
                label: Text(isTaskChanged() ? "Discard Changes" : "Go Back"),
                style: ElevatedButton.styleFrom(backgroundColor: isTaskChanged() ? Colors.red : Colors.blue),
              ),
            ),
    
            // update changes
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop([true, widget.toDoTaskPerIndex]),
                icon: const Icon(Icons.check),
                label: const Text("Complete task"),
                style: ElevatedButton.styleFrom(backgroundColor: getTaskCompletion(widget.toDoTaskPerIndex["subtasks"]) == widget.toDoTaskPerIndex["subtasks"].length ? Colors.green : Colors.grey),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pop([false, widget.toDoTaskPerIndex]),
          backgroundColor: isTaskChanged() ? Colors.green : Colors.grey,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}