import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:myapp/story_book.dart';

class IndexPage extends StatefulWidget {
  final StoryBook storyBook;

  const IndexPage({super.key, required this.storyBook});

  @override
  State<IndexPage> createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(
              base64Decode(widget.storyBook.coverContent.substring(22)),
            ), 
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(0.5),
          BlendMode.dstATop,
        )),
      ),
      child: Center(
        child: Markdown(
            data: widget.storyBook.indexContent,
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
