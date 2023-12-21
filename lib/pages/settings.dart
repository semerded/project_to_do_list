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
              subTitle: AppLayout.colorAdaptivText("TODO"),
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
              subTitle: AppLayout.colorAdaptivText("Enable dark mode"),
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
                subTitle: AppLayout.colorAdaptivText("Whether the search tool searches in the descriptions or not"),
                leading: Switch(
                  value: onlySearchInTitle,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      onlySearchInTitle = value;
                    });
                  },
                )),
            settingsCard(
                title: settingsCardTitle("Search Tasks In Subtasks"),
                subTitle: AppLayout.colorAdaptivText("Whether the search tool also searches in the subtasks titles"),
                leading: Switch(
                  value: searchInSubTasks,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      searchInSubTasks = value;
                    });
                  },
                )),
            settingsCard(
                title: settingsCardTitle("Auto Move Task To In Progress"),
                subTitle: AppLayout.colorAdaptivText("If enabled, a task with one subtask completed will be moved to In Progress automatically"),
                leading: Switch(
                  value: false,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      // onlySearchInTitle = !onlySearchInTitle;
                    });
                  },
                )),
            settingsCard(
                title: settingsCardTitle("Set 'In Progress' tab as default"),
                subTitle: AppLayout.colorAdaptivText("If enabled, the 'In Progress' tab will be the default tab to show when opening the app. Otherwise it will be the 'To Do' tab"),
                leading: Switch(
                  value: defaultTab == 1 ? true : false,
                  activeColor: colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        defaultTab = 1;
                      } else {
                        defaultTab = 0;
                      }
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
