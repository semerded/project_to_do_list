import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';
import 'package:project_to_do_list/functions/setting_functions.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  void applyNewColor(color) {
    setState(() {
      colorScheme.setPrimary(color);
      accentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          Navigator.of(context).pop(true);
          return false;
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Settings"),
          backgroundColor: colorScheme.primary,
        ),
        body: ListView(
          children: [
            ///
            /// app accent color
            ///
            settingsCard(
              title: DropdownButton(
                dropdownColor: Colors.grey[700],
                value: null,
                hint: AppLayout.colorAdaptivText("Accent Color: $accentColor"),
                items: colorSchemeChoice.map(
                  (String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (value) => applyNewColor(value),
              ),
            ),
    
            ///
            /// show programming color
            ///
            settingsCard(
              title: settingsCardTitle("Show Programming Color"),
              leading: Switch(
                value: showProgrammingColor,
                activeColor: colorScheme.primary,
                onChanged: (value) => setState(() {
                  showProgrammingColor = value;
                }),
              ),
            ),
    
            ///
            /// dark mode
            ///
            settingsCard(
              title: settingsCardTitle("Dark Mode"),
              leading: Switch(
                value: darkMode,
                activeColor: colorScheme.primary,
                onChanged: (value) => setState(() {
                  colorScheme.switchLightDarkMode();
                  darkMode = value;
                }),
              ),
            ),
            settingsCard(
                title: settingsCardTitle("Only Search In Title"),
                leading: Switch(
                  value: onlySearchInTitle,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      onlySearchInTitle = !onlySearchInTitle;
                    });
                  },
                )),
            settingsCard(
                title: settingsCardTitle("Auto Move Task To In Progress"),
                leading: Switch(
                  value: false,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      // onlySearchInTitle = !onlySearchInTitle;
                    });
                  },
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pop(true),
          backgroundColor: colorScheme.primary,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}