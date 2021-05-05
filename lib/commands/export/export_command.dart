import 'package:args/command_runner.dart';
import 'package:note2md/commands/export/subcommands/article_command.dart';
import 'package:note2md/commands/export/subcommands/archives_command.dart';

class ExportCommand extends Command {
  ExportCommand() {
    addSubcommand(ArticleCommand());
    addSubcommand(ArchivesCommand());
  }

  @override
  String get name => 'export';

  @override
  String get description => 'Export note article to markdown file';
}
