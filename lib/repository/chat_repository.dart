import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini_ai_app/utils/utils.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  static Map<String, String> headers = {'Content-Type': 'application/json'};
  String urlChat =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${dotenv.env["APIKEY"]}';
  String urlImage =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${dotenv.env["APIKEY"]}';
  static Future chatActionSend(
    ChatMessage message,
    List<ChatMessage> messages,
    List<ChatUser> typingState,
    bool isChat,
    String? image,
  ) async {
    var dataChat = {
      "contents": [
        {
          "parts": [
            {"text": message.text}
          ]
        }
      ]
    };

    final imageDataChat = {
      "contents": [
        {
          "parts": [
            {"text": message.text},
            {
              "inlineData": {
                "mimeType": "image/jpeg",
                "data": image,
              }
            }
          ]
        }
      ],
    };
    try {
      typingState.add(Utility.geminiBot);
      messages.insert(0, message);
      var response = await http.post(
          Uri.parse(
            !isChat ? ChatRepository().urlChat : ChatRepository().urlImage,
          ),
          headers: headers,
          body: jsonEncode(!isChat ? dataChat : imageDataChat));
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ChatMessage botMessage = ChatMessage(
          text: result['candidates'][0]['content']['parts'][0]['text'],
          user: Utility.geminiBot,
          createdAt: DateTime.now(),
        );
        messages.insert(0, botMessage);
      } else {
        debugPrint('result status code : ${response.statusCode}');
        debugPrint('result : $result');
      }
    } catch (e) {
      debugPrint('ERROR CHAT ACTION SEND ${e.toString()}');
      ChatMessage botMessage = ChatMessage(
        text: 'Sorry your request cannot be show right now :(',
        user: Utility.geminiBot,
        createdAt: DateTime.now(),
      );
      messages.insert(0, botMessage);
    } finally {
      typingState.remove(Utility.geminiBot);
    }
  }
}
