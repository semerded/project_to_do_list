import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';
import 'package:project_to_do_list/components/ui/app_widgets.dart';

Widget settingsCard({dynamic leading, dynamic title}) {
  return Card(
    color: colorScheme.card,
    elevation: 2,
    child: ListTile(
      title: title,
      leading: leading,
    ),
  );
}

Widget settingsCardTitle(String title) {
  return AppLayout.colorAdaptivText(title);
}
