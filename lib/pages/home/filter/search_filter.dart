import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';

typedef OnChangedCallback = void Function(String value);

class FilterBySearch extends StatefulWidget {
  final OnChangedCallback onChanged;

  const FilterBySearch({required this.onChanged, super.key});

  @override
  State<FilterBySearch> createState() => FilterBySearchState();
}

class FilterBySearchState extends State<FilterBySearch> {
  final filterBar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        cursorColor: colorScheme.primary,
        decoration: InputDecoration(
          /// when inactive
          enabledBorder: AppLayout.inactiveBorder(),

          /// when active
          focusedBorder: AppLayout.activeBorder(),
          hintText: "Search for task",
          hintStyle: TextStyle(color: colorScheme.text),
          iconColor: colorScheme.primary,
          icon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.cancel),
            color: colorScheme.primary,
            onPressed: () => setState(() {
              widget.onChanged("");
              filterBar.clear();
              FocusManager.instance.primaryFocus?.unfocus();
            }),
          ),
        ),
        controller: filterBar,
        style: TextStyle(color: colorScheme.text, decorationColor: colorScheme.primary),
        onChanged: (value) => setState(() {
          widget.onChanged(value);
        }),
      ),
    );
  }
}
