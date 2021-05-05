import 'dart:io';

import 'package:note2md/src/internal/markdown.dart';

class FileSaver {
  static Future<void> saveFromMarkdown(Markdown markdown) async {
    const directory = './outputs';
    await Directory(directory).create(recursive: true);
    final file = File('$directory/${markdown.title.replaceAll("/", "")}.md');
    await file.create();
    await file.writeAsString(markdown.content);
  }
}
