import 'dart:io';

import 'package:dcli/dcli.dart';

final templateDir =
    Directory('${DartScript.self.pathToScriptDirectory}/../templates');

enum Variable {
  AOC_DAY,
  AOC_DAY_PADDED,
  AOC_TITLE,
}

void main() async {
  stdout.write('Day: ');
  final day = int.parse(stdin.readLineSync()!);

  final String paddedDay = day.toString().padLeft(2, '0');
  final Directory projectDir =
      Directory('${Directory.current.path}/day$paddedDay');

  if (await projectDir.exists()) {
    print('Directory already exists at ${projectDir.path}');
    return;
  }
  print('(${projectDir.path})');

  stdout.write('Title: ');
  final title = stdin.readLineSync()!;

  stdout.write('Generate files at ${projectDir.path}? (y/n) ');
  final String answer = stdin.readLineSync()!;

  if (answer.toLowerCase() != 'y') {
    print('Aborted');
    return;
  }

  if (!await templateDir.exists()) {
    print('Templates directory not found at ${templateDir.path}');
    return;
  }

  await projectDir.create(recursive: true);

  final Map<Variable, String> variables = {
    Variable.AOC_DAY: day.toString(),
    Variable.AOC_DAY_PADDED: paddedDay,
    Variable.AOC_TITLE: title,
  };

  // copy all files from template dir to project dir
  await for (final entity in templateDir.list(recursive: true)) {
    if (entity is File) {
      final file = await createFile(entity, projectDir, variables);
      print('Created file: ${file.path}');
    } else if (entity is Directory) {
      final dir = await createDirectory(entity, projectDir, variables);
      print('Created directory: ${dir.path}');
    }
  }
}

String replaceAllWithVariables(
    String content, Map<Variable, String> variables) {
  String newContent = content;
  for (final MapEntry<Variable, String> entry in variables.entries) {
    newContent = newContent.replaceAll('\${${entry.key.name}}', entry.value);
  }
  return newContent;
}

Future<File> createFile(
    File f, Directory projectDir, Map<Variable, String> variables) async {
  final String relativePath = replaceAllWithVariables(
          f.path.substring(templateDir.path.length + 1), variables)
      // remove .template suffix
      .replaceAll('.template', '');
  final File newFile = File('${projectDir.path}/$relativePath');
  await newFile.create(recursive: true);
  // write file content
  final String content = await f.readAsString();
  await newFile.writeAsString(replaceAllWithVariables(content, variables));
  return newFile;
}

Future<Directory> createDirectory(
    Directory d, Directory projectDir, Map<Variable, String> variables) async {
  final String relativePath = replaceAllWithVariables(
      d.path.substring(templateDir.path.length + 1), variables);
  final Directory newDir = Directory('${projectDir.path}/$relativePath');
  await newDir.create(recursive: true);
  return newDir;
}
