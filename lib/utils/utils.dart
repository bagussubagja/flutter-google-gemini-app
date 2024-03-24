import 'package:dash_chat_2/dash_chat_2.dart';

class Utility {
  static ChatUser currentUser = ChatUser(
    id: '1',
    firstName: 'USER',
  );

  static ChatUser geminiBot = ChatUser(
    id: '2',
    firstName: 'Google',
    lastName: 'Gemini',
  );
  static List<ChatMessage> messages = [];
  static List<ChatUser> typing = [];
}
