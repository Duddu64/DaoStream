class ChapterEntity {
  final String id;
  final String manhuaId; 
  final String publisherPubKey; 
  final double chapterNumber; // Suporta capitulos decimais como 10.5
  final String title;
  final List<String> pageUrls; 
  final DateTime publishedAt;

  ChapterEntity({
    required this.id,
    required this.manhuaId,
    required this.publisherPubKey,
    required this.chapterNumber,
    required this.title,
    required this.pageUrls,
    required this.publishedAt,
  });
}