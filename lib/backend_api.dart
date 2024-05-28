import 'dart:convert';

import 'package:myapp/chapter.dart';
import 'package:myapp/story_book.dart';
import 'package:http/http.dart' as http;

class BackendApi {
  static const token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2Nsb3VkLmdvb2dsZS5jb20vd29ya3N0YXRpb25zIiwiYXVkIjoiaWR4LXRoZS1sZWFybmluZy1nYW1lcy0xNzE2ODQ1Mjc0OTU0LmNsdXN0ZXItdnB4anFkc3RmemdzNnFlaWFmN3JkbHNxcmMuY2xvdWR3b3Jrc3RhdGlvbnMuZGV2IiwiaWF0IjoxNzE2ODY3MDU2LCJleHAiOjE3MTY4NzA2NTV9.UwclKSesN69DgmNgqCmK31kED4UkE-_FaYPGo1Ln6YGjm9jGn1CEYlEgKJEi6KwXWXaq5juN2pvYLY5O2Og2IEjf93y1U77zy18-BBNplx3vpDXXMlWiEUKEqO-ZS0Aj1CfeEWV_BhkXUK4FaNVzKK2fQpFRw9h-zXp2smHFlV9_f5PTm7rOQaZ76whemxhHbbNCL7LAg8BneS15n2HM0LkCHAA9S2Uxbl8ajl6qEGM9xQNl7xK6yvWJxNQ9TCCc8EbF5qtluSXdauDOK8vIhpzhsE5qTr_nPGWuLU8IDtgtYaMW5O-GhvpVIA2vkOoQ7LxGKRCothxcUGv2048_tA";
  static const backendBaseUrl = 'https://3401-idx-the-learning-games-1716845274954.cluster-vpxjqdstfzgs6qeiaf7rdlsqrc.cloudworkstations.dev';


  static const storyBookFlowUrl = "${BackendApi.backendBaseUrl}/storyBookFlow";
  static const generateChapterBookFlowUrl = "${BackendApi.backendBaseUrl}/generateChapterBookFlow";

  static Future<StoryBook> fetchStoryBook() async {
    final response = await http.post(
        Uri.parse(BackendApi.storyBookFlowUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${BackendApi.token}'
        },
        body: jsonEncode(<String, Object>{
          "data": {
            "audience": "teenagers",
            "numChapters": 3,
            "topic": "física cuántica",
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
      throw Exception('Failed to load story book');
    }
  }

  static Future<Chapter> fetchChapter(
    int chapter, String indexContent, String audience, String language) async {
  final response = await http.post(
      Uri.parse(BackendApi.generateChapterBookFlowUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${BackendApi.token}'
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
