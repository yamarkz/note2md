import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:puppeteer/puppeteer.dart' as puppeteer;
import 'package:note2md/src/internal/article.dart';
import 'package:note2md/src/internal/page.dart';
import 'package:note2md/src/internal/archives.dart';
import 'package:note2md/src/utils/io.dart';

class Note {
  static bool isNoteDomain(String url) => url.contains('note.com');

  static bool isArchivesPath(String url) => url.contains('archives');

  static Future<Archives> fetchArchivesPage(String archivesUrl) async {
    printInfo('--- Fetch archivesUrl of $archivesUrl ---');
    final archiveUrl = Uri.parse(archivesUrl);
    final origin = archiveUrl.origin;
    final archiveUrls = await fetchArchiveUrls(archiveUrl.toString());
    final browser = await puppeteer.puppeteer.launch();
    final page = await browser.newPage();
    final articles = <Article>[];
    await Future.forEach<String>(archiveUrls, (archiveUrl) async {
      printInfo('--- Fetch archiveUrl of $archiveUrl ---');
      await page.goto(archiveUrl, wait: puppeteer.Until.networkIdle);
      const moreButtonSelector = ".o-timelineHome__more";
      if (await page.$OrNull(moreButtonSelector) != null) {
        await page.click('.o-timelineHome__moreButton');
        await page.waitForSelector(".m-infiniteScroll");
        await page.autoScroll();
      }
      final content = await page.evaluate('document.documentElement.outerHTML');
      final html = parser.parse(content);
      final articleRaws = html.getElementsByClassName('o-timelineHome__item');
      final articleUrls = articleRaws.map((articleRaw) {
        final path = articleRaw
            .getElementsByClassName('renewal-p-cardItem__title')[0]
            .children[0]
            .attributes['href'];
        return '$origin$path';
      }).toList();
      articles.addAll(await fetchArticles(articleUrls));
    });
    page.close();
    return Archives(articles: articles);
  }

  static Future<List<String>> fetchArchiveUrls(String archiveUrl) async {
    final url = Uri.parse(archiveUrl);
    final origin = url.origin;
    final response = await http.get(url);
    final document = parser.parse(response.body);
    final archiveRaws = document.getElementsByClassName('m-archiveList__link');
    final archiveUrls = archiveRaws.map((articleRaw) {
      final path = articleRaw.attributes['href'];
      return '$origin$path';
    }).toList();
    return archiveUrls;
  }

  static Future<List<Article>> fetchArticles(List<String> articleUrls) async {
    final articles = <Article>[];
    await Future.forEach<String>(articleUrls, (articleUrl) async {
      final article = await fetchArticle(articleUrl);
      articles.add(article);
    });
    return articles;
  }

  static Future<Article> fetchArticle(String articleUrl) async {
    printInfo('--- Fetch articleUrl of $articleUrl ---');
    final url = Uri.parse(articleUrl);
    final response = await http.get(url);
    final document = parser.parse(response.body);

    String author() {
      final elements =
          document.body!.getElementsByClassName('o-noteContentHeader__name');
      return elements[0].children[0].text.trim();
    }

    String title() {
      final elements =
          document.body!.getElementsByClassName('o-noteContentText__title');
      if (elements.isEmpty) return '';
      return elements[0].text.trim();
    }

    String headerImageUrl() {
      final elements =
          document.body!.getElementsByClassName('o-noteEyecatch__image');
      if (elements.isEmpty) return '';
      return elements[0].attributes['src']!.trim();
    }

    String publishedAt() {
      final elements =
          document.body!.getElementsByClassName('o-noteContentHeader__date');
      if (elements.isEmpty) return '';
      return elements[0].children[0].text.trim();
    }

    String like() {
      final elements =
          document.body!.getElementsByClassName('o-noteContentText__likeCount');
      if (elements.isEmpty) return '0';
      return elements[0].text.trim();
    }

    String body() {
      final elements = document.body!
          .getElementsByClassName('note-common-styles__textnote-body');
      if (elements.isEmpty) return '';
      return elements[0]
          .children
          .map((e) => "${e.outerHtml}\n")
          .toList()
          .join();
    }

    List<String> tags() {
      final tagsRaw = document.body!.getElementsByClassName('a-tag__label');
      return tagsRaw.map((e) => e.text.trim()).toList();
    }

    return Article(
      title: title(),
      headerImageUrl: headerImageUrl(),
      publishedAt: publishedAt(),
      author: author(),
      body: body(),
      like: like(),
      tags: tags(),
    );
  }
}
