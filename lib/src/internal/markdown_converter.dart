import 'package:html/parser.dart' as parser;

import 'package:note2md/src/internal/article.dart';
import 'package:note2md/src/internal/element.dart';
import 'package:note2md/src/internal/markdown.dart';

class MarkdownConverter {
  static Future<Markdown> convertFromArticle(Article article) async {
    final content = Markdown.template
        .replaceAll('replaceTitle', article.title)
        .replaceAll('replaceTags', article.tags.toString())
        .replaceAll('replaceCoverImage', article.headerImageUrl)
        .replaceAll('replacePublishedAt', article.publishedAt)
        .replaceAll('replaceAuthor', article.author)
        .replaceAll('replaceLike', article.like)
        .replaceAll('replaceBody', convertMarkdownFormat(article.body));
    return Markdown(title: article.title, content: content);
  }

  static String convertMarkdownFormat(String rawText) {
    final List<String> result = [];
    final elements = parser.parse(rawText).body!.children;
    for (final element in elements) {
      if (element.isH1) {
        result.add('\n# ${element.text}\n');
        continue;
      }
      if (element.isH2) {
        result.add('\n## ${element.text}\n');
        continue;
      }
      if (element.isH3) {
        result.add('\n### ${element.text}\n');
        continue;
      }
      if (element.isP) {
        if (element.children.isNotEmpty && element.children[0].isImg) {
          final imageUrl = element.children[0].attributes['data-src'];
          final alt = element.children[0].attributes['alt'];
          result.add('\n![$alt]($imageUrl)');
        } else {
          final text = parser
              .parse(
                element.outerHtml
                    .replaceAll('<br>', '\n')
                    .replaceAll('<b>', '**')
                    .replaceAll('</b>', '** ')
                    .trim(),
              )
              .body!
              .text;
          result.add('\n$text');
        }
        continue;
      }
      if (element.isFigure) {
        final elementByLink = element.getElementsByTagName('a');
        if (elementByLink.isNotEmpty) {
          final url = elementByLink[0].attributes['href'];
          result.add('\n[Link]($url)');
        }
        continue;
      }
      if (element.isPre) {
        final elementBycode = element.getElementsByTagName('code');
        if (elementBycode.isNotEmpty) {
          final text = elementBycode[0].text;
          result.add('\n ``` \n $text \n ```');
        }
        continue;
      }
    }
    return result.join('\n');
  }
}
