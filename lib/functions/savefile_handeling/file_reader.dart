import 'dart:convert';
import 'package:project_to_do_list/functions/savefile_handeling/get_path.dart';

Future<Map> readLocalJSONtoDoTaskSaveFile() async {
  try {
    final file = await localPath;
    // Read the file
    final contents = await file.readAsString();
    return jsonDecode(contents);
  } catch (e) {
    // If encountering an error, return 0
    return {"toDo": [], "inProgress": [], "completed": []};
  }
}
