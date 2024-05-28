import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:myapp/chapter.dart';
import 'package:myapp/story_book.dart';

class ChapterPage extends StatefulWidget {
  final StoryBook storyBook;
  final Chapter chapter;

  const ChapterPage({super.key, required this.storyBook, required this.chapter});

  @override
  State<ChapterPage> createState() => _ChapterPage();
}

class _ChapterPage extends State<ChapterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 172, 172, 172)),
      child: Center(
        child: Markdown(
            data: widget.chapter.text,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(
                fontSize: 32,
                fontFamily: 'Droid Sans',
              ),
              h2: const TextStyle(
                fontSize: 24,
                fontFamily: 'Droid Sans',
              ),
              p: const TextStyle(fontSize: 16, fontFamily: 'Droid Sans'),
            )),
      ),
    );
  }
}
