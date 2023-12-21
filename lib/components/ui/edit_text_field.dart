import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';

typedef TextFieldCallback = void Function(String value);

class TaskEditTextField extends StatefulWidget {
  final String editDescription;
  final String originalText;
  final TextFieldCallback textFieldCallback;
  const TaskEditTextField({required this.editDescription, required this.originalText, required this.textFieldCallback, super.key});

  @override
  State<TaskEditTextField> createState() => _TaskEditTextFieldState();
}

class _TaskEditTextFieldState extends State<TaskEditTextField> {
  String editDescription = "Unknown";
  TextEditingController textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editDescription = widget.editDescription;
    textFieldController.text = widget.originalText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppLayout.colorAdaptivText("Edit $editDescription Of Task"),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.undo),
                color: colorScheme.primary,
                onPressed: () => setState(() {
                  widget.textFieldCallback(widget.originalText);
                  textFieldController.text = widget.originalText;
                }),
              ),
              enabledBorder: AppLayout.inactiveBorder(),
              focusedBorder: AppLayout.activeBorder(),
              errorBorder: AppLayout.inactiveBorder(),
              focusedErrorBorder: AppLayout.activeBorder(),
              hintText: "Edit the $editDescription for your project",
              hintStyle: TextStyle(color: colorScheme.text),
            ),
            controller: textFieldController,
            style: TextStyle(color: colorScheme.text),
            cursorColor: colorScheme.primary,
            onChanged: (value) => widget.textFieldCallback(value),
          ),
        )
      ],
    );
  }
}
