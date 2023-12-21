import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';

Widget settingsCard({dynamic leading, dynamic title, dynamic subTitle}) {
  return Card(
    color: colorScheme.card,
    elevation: 2,
    child: ListTile(
      title: title,
      subtitle: subTitle,
      leading: leading,
    ),
  );
}

Widget settingsCardTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: colorScheme.primary,
    ),
  );
}
