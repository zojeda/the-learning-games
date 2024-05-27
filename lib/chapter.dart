class Chapter {
  final String title;
  final String text;
  final int chapter;

  const Chapter(
      {required this.title, required this.text, required this.chapter});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return switch (json['result']) {
      {
        'chapter': int chapter, 
        'title': String title, 
        'text': String text
      } => Chapter(chapter: chapter, title: title, text: text),
      _ => throw const FormatException('Failed to load Chapter.'),
    };
  }
}
