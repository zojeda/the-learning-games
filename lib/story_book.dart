class StoryBook {
  final String topic;
  final String indexContent;
  final String audience;
  final String language;
  final int numChapters;
  final String coverContent;
  final String coverContentType;

  const StoryBook(
      {required this.topic,
      required this.indexContent,
      required this.audience,
      required this.language,
      required this.numChapters,
      required this.coverContent,
      required this.coverContentType});

  factory StoryBook.fromJson(Map<String, dynamic> json) {
    return switch (json['result']) {
      {'topic': String topic, 
       'indexContent': String indexContent,
       'audience': String audience,
       'language': String language,
       'numChapters': int numChapters,
       'coverContent': String coverContent,
       'coverContentType': String coverContentType,
       } => StoryBook(
          topic: topic,
          indexContent: indexContent,
          audience: audience,
          language: language,
          numChapters: numChapters,
          coverContent: coverContent,
          coverContentType: coverContentType
        ),
      _ => throw const FormatException('Failed to load story book.'),
    };
  }
}
