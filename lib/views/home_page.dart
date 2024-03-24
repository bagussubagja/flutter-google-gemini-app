import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini_ai_app/repository/chat_repository.dart';
import 'package:flutter_gemini_ai_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? fileImage;
  final ImagePicker _imagePicker = ImagePicker();
  getImage(ImageSource imageSource) async {
    XFile? result = await _imagePicker.pickImage(source: imageSource);

    if (result != null) {
      setState(() {
        fileImage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (fileImage != null)
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.file(File(fileImage!.path)),
                ),
              ),
            DashChat(
              typingUsers: Utility.typing,
              messageListOptions: const MessageListOptions(
                showDateSeparator: true,
              ),
              messageOptions: MessageOptions(
                showTime: true,
                showOtherUsersName: true,
                showCurrentUserAvatar: true,
                showOtherUsersAvatar: true,
                userNameBuilder: (user) {
                  return Text(user.getFullName());
                },
                avatarBuilder: (user, onPressAvatar, onLongPressAvatar) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.network(user.id == '1'
                            ? Utility.userAvatar
                            : Utility.botAvatar),
                      ),
                    ),
                  );
                },
              ),
              currentUser: Utility.currentUser,
              onSend: (_) async {
                setState(() {});
                List<int> imageBytes = File(fileImage!.path).readAsBytesSync();
                String base64File = base64.encode(imageBytes);
                await ChatRepository.chatActionSend(
                  _,
                  Utility.messages,
                  Utility.typing,
                  fileImage != null,
                  base64File,
                );
                setState(() {});
              },
              messages: Utility.messages,
              inputOptions: InputOptions(
                leading: [
                  IconButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    icon: const Icon(
                      Icons.photo_size_select_actual_outlined,
                      color: Colors.teal,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
