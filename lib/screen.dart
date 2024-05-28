import 'package:myapp/index_page.dart';
import 'package:myapp/story_book.dart';

import 'page.dart';
import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';

class HomeScreen extends StatefulWidget {
  final StoryBook storyBook;
  const HomeScreen({super.key, required this.storyBook});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: PageFlipWidget(
        key: _controller,
        backgroundColor: const Color.fromARGB(255, 192, 196, 197),
        initialIndex: 0,
        // isRightSwipe: true,
        lastPage: Container(
            color: Colors.white,
            child: const Center(child: Text('Last Page !'))),
        children: <Widget>[
          for (var i = 0; i < widget.storyBook.numChapters+1; i++)
            i == 0 
              ? IndexPage(storyBook: widget.storyBook)
              : DemoPage(storyBook: widget.storyBook, page: i),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.forward),
        onPressed: () {
          _controller.currentState?.nextPage();
        },
      ),
    );
  }
}
