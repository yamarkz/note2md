import 'package:args/command_runner.dart';
import 'package:note2md/commands/commands.dart';
import 'package:note2md/note2md.dart';

Future<void> main(List<String> arguments) async {
  final runner = CommandRunner(
    'note2md',
    'note2md command-line interface.',
  )..addCommand(ExportCommand());

  try {
    await runner.run(arguments);
  } catch (error) {
    printErrorAndExit('Error: $error');
  }
}
