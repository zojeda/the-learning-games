import 'package:myapp/backend_api.dart';
import 'package:myapp/story_book.dart';

import 'screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<StoryBook> futureStoryBook;

  @override
  void initState() {
    super.initState();
    futureStoryBook = BackendApi.fetchStoryBook();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Center(
            child: FutureBuilder<StoryBook>(
          future: futureStoryBook,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen(storyBook: snapshot.data!);
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
