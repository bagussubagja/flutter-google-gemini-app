import 'package:dash_chat_2/dash_chat_2.dart';

class Utility {
  static ChatUser currentUser = ChatUser(
    id: '1',
    firstName: 'User',
  );

  static ChatUser geminiBot = ChatUser(
    id: '2',
    firstName: 'Google',
    lastName: 'Gemini',
  );
  static List<ChatMessage> messages = [];
  static List<ChatUser> typing = [];

  static String userAvatar = 'https://placehold.co/25x25.png';
  static String botAvatar =
      'https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png';
}
