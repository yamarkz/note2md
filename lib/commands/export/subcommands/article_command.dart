import 'package:args/command_runner.dart';
import 'package:note2md/note2md.dart';

class ArticleCommand extends Command {
  ArticleCommand() {
    argParser.addOption(
      'url',
      abbr: 'u',
      help: 'Specify the url where the article needs to be exported.',
    );
  }

  @override
  String get name => 'article';

  @override
  String get description => 'Export a Article snippet';

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
    await _exportArticle(url);
  }

  Future<void> _exportArticle(String articleUrl) async {
    printInfo('--- Start export of $articleUrl ---');
    try {
      final article = await Note.fetchArticle(articleUrl);
      final markdown = await MarkdownConverter.convertFromArticle(article);
      await FileSaver.saveFromMarkdown(markdown);
      printSuccess('--- Success export of $articleUrl ---');
      printSuccessAndExit('--- Success command ---');
    } catch (error) {
      printErrorAndExit('--- Error: $error ---');
    }
  }
}
