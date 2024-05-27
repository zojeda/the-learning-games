import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PageContent extends StatefulWidget {
  final String data;

  const PageContent({super.key, required this.data});

  @override
  State<PageContent> createState() => _PageContent();
}

class _PageContent extends State<PageContent> {
  @override
  Widget build(BuildContext context) {
    return Markdown(
        data: widget.data,
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
        ));
  }
}
