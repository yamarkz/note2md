class Markdown {
  final String title;
  final String content;

  const Markdown({
    required this.title,
    required this.content,
  });

  static String get template {
    return '''
---
title: replaceTitle
tags: replaceTags
coverImage: replaceCoverImage
publishedAt: replacePublishedAt
author: replaceAuthor
like: replaceLike
---

replaceBody

''';
  }
}
