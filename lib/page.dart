import 'package:flutter/material.dart';
import 'package:myapp/backend_api.dart';
import 'package:myapp/chapter.dart';
import 'package:myapp/chapter_page.dart';
import 'package:myapp/story_book.dart';

class DemoPage extends StatefulWidget {
  final int page;
  final StoryBook storyBook;

  const DemoPage({super.key, required this.page, required this.storyBook});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  late Future<Chapter> futureChapter;

  @override
  void initState() {
    super.initState();
    futureChapter = BackendApi.fetchChapter(widget.page, widget.storyBook.indexContent,
        widget.storyBook.audience, widget.storyBook.language);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: FutureBuilder<Chapter>(
      future: futureChapter,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChapterPage(storyBook: widget.storyBook, chapter: snapshot.data!);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
      // home: HomeScreen(),
    )));
  }
}
