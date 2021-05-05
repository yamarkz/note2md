import 'package:args/command_runner.dart';
import 'package:note2md/note2md.dart';

class ArchivesCommand extends Command {
  ArchivesCommand() {
    argParser.addOption(
      'url',
      abbr: 'u',
      help: 'Specify the url where the archives needs to be exported.',
    );
  }

  @override
  String get name => 'archives';

  @override
  String get description => 'Export a Archives snippet';

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.length > 1) {
      printErrorAndExit('--- Too many arguments specified ---');
    }
    final url = argResults!['url'] as String;
    if (!Note.isNoteDomain(url)) {
      printErrorAndExit('--- No note.com domain specified ---');
    }
    if (!Note.isArchivesPath(url)) {
      printErrorAndExit('--- No archives url specified ---');
    }
    await _exportArchives(url);
  }

  Future<void> _exportArchives(String archivesUrl) async {
    printInfo('--- Start export of $archivesUrl ---');
    try {
      final archives = await Note.fetchArchivesPage(archivesUrl);
      await Future.forEach<Article>(archives.articles, (article) async {
        final markdown = await MarkdownConverter.convertFromArticle(article);
        await FileSaver.saveFromMarkdown(markdown);
        printSuccess('--- Success export of ${article.title} ---');
      });
      printSuccessAndExit('--- Success command ---');
    } catch (error) {
      printErrorAndExit('--- Error: $error ---');
    }
  }
}
