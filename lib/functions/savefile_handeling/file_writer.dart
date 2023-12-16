import 'dart:convert';
import 'dart:io';
import 'package:project_to_do_list/functions/savefile_handeling/get_path.dart';

Future<File> writeLocalJSONtoDoTaskSaveFile(jsonDataAsJsonObject) async {
  final file = await localPath;

  // Write the file
  return file.writeAsString(jsonEncode(jsonDataAsJsonObject));
}