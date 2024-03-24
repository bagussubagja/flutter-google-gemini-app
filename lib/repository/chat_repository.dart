import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini_ai_app/utils/utils.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  static Map<String, String> headers = {'Content-Type': 'application/json'};
  static Future chatActionSend(
    ChatMessage message,
    List<ChatMessage> messages,
    List<ChatUser> typingState,
  ) async {
    var data = {
      "contents": [
        {
          "parts": [
            {"text": message.text}
          ]
        }
      ]
    };
    try {
      typingState.add(Utility.geminiBot);
      messages.insert(0, message);
      var response = await http.post(
          Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${dotenv.env["APIKEY"]}',
          ),
          headers: headers,
          body: jsonEncode(data));
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
    } finally {
      typingState.remove(Utility.geminiBot);
    }
  }
}
/*
onSendAction(ChatMessage message) async {
    typing.add(bot);
    var data = {
      "contents": [
        {
          "parts": [
            {
              "text": message.text,
            }
          ]
        }
      ]
    };
    messages.insert(0, message);
    setState(() {});
    await http
        .post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
      ),
      headers: headers,
      body: jsonEncode(data),
    )
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print('result $result');
        // print(result['candidates'][0]['content']['parts'][0]['text']);
        ChatMessage botMessage = ChatMessage(
            user: bot,
            createdAt: DateTime.now(),
            text: result['candidates'][0]['content']['parts'][0]['text']);
        messages.insert(0, botMessage);
        setState(() {});
      } else {
        print(value.statusCode);
      }
    }).catchError((e) {
      print('ERROR $e');
    });
    typing.remove(bot);
    setState(() {});
  }
*/