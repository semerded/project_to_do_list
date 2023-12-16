import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return File('$path/JSONtaskSaveFile.json');
}