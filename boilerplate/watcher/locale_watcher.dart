// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as path;

void main(List<String> arguments) {
  const directoryPath = '../assets/translations';

  final watcher = DirectoryWatcher(directoryPath);

  print('Watching directory: $directoryPath');


  watcher.events.listen((event) {
    if (event.type == ChangeType.MODIFY) {
      print('File modified: ${event.path}');
      final scriptRunnerPath = path.absolute('locale_script.dart');
      Process.start('clear', []);
      Process.start('dart', [
        scriptRunnerPath,
        (event.path.split("/").last.split(".").first)
      ]).then((process) {
        process.stdout.transform(utf8.decoder).listen((data) {
          print('Script output: $data');
        });
        process.stderr.transform(utf8.decoder).listen((data) {
          print('Script error: $data');
        });
      });
    }
  });
}
