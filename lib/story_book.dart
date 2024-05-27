class StoryBook {
  final String topic;
  final String indexContent;
  final String audience;
  final String language;
  final int numChapters;

  const StoryBook(
      {required this.topic,
      required this.indexContent,
      required this.audience,
      required this.language,
      required this.numChapters});

  factory StoryBook.fromJson(Map<String, dynamic> json) {
    return switch (json['result']) {
      {'topic': String topic, 
       'indexContent': String indexContent,
       'audience': String audience,
       'language': String language,
       'numChapters': int numChapters
       } => StoryBook(
          topic: topic,
          indexContent: indexContent,
          audience: audience,
          language: language,
          numChapters: numChapters
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
