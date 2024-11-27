class Blog {
  final String id;
  final String posterID;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String? posterName;
  Blog(
      {required this.id,
      required this.posterID,
      required this.title,
      required this.content,
      required this.imageUrl,
      required this.topics,
      required this.updatedAt,
      this.posterName});
}
