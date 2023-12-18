import 'package:flutter/material.dart';
import 'package:project_to_do_list/components/globals.dart';

RoundedRectangleBorder priorityBorder() {
  return RoundedRectangleBorder(
    side: BorderSide(width: 5, color: colorScheme.text),
    borderRadius: BorderRadius.circular(5),
  );
}
