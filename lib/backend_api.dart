import 'dart:convert';

import 'package:myapp/chapter.dart';
import 'package:myapp/story_book.dart';
import 'package:http/http.dart' as http;

class BackendApi {
  static const backendBaseUrl = 'https://localhost:3400';
  static const storyBookFlowUrl = "${BackendApi.backendBaseUrl}/storyBookFlow";
  static const generateChapterBookFlowUrl = "${BackendApi.backendBaseUrl}/generateChapterBookFlow";

  static Future<StoryBook> fetchStoryBook() async {
    final response = await http.post(
        Uri.parse(BackendApi.storyBookFlowUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          "data": {
            "audience": "adults",
            "numChapters": 5,
            "topic": "historia de las ciencias",
            "language": "spanish"
          }
        }));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return StoryBook.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<Chapter> fetchChapter(
    int chapter, String indexContent, String audience, String language) async {
  final response = await http.post(
      Uri.parse(BackendApi.generateChapterBookFlowUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "data": {
          "audience": audience,
          "chapter": chapter,
          "indexContent": indexContent,
          "language": language
        }
      }));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Chapter.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load chapter');
  }
}

}
