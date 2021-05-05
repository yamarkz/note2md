class Article {
  final String title;
  final String headerImageUrl;
  final String publishedAt;
  final String author;
  final String body;
  final String like;
  final List<String> tags;

  const Article({
    required this.title,
    required this.headerImageUrl,
    required this.publishedAt,
    required this.author,
    required this.body,
    required this.like,
    required this.tags,
  });
}
