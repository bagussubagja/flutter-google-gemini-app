import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini_ai_app/repository/chat_repository.dart';
import 'package:flutter_gemini_ai_app/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DashChat(
          typingUsers: Utility.typing,
          currentUser: Utility.currentUser,
          onSend: (_) async {
            setState(() {});
            await ChatRepository.chatActionSend(
              _,
              Utility.messages,
              Utility.typing,
            );
            setState(() {});
          },
          messages: Utility.messages,
          inputOptions: InputOptions(
            leading: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.photo_size_select_actual_outlined,
                  color: Colors.teal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
