import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser myself = ChatUser(id: '1', firstName: 'ali');
  ChatUser botChat = ChatUser(id: '2', firstName: 'Gemini');

  var messgaeUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBp4toEclXdVzjVSojnkUSEjVHXmty6tyQ';

  List<ChatMessage> allMessages = [];

  List<ChatUser> typing = [];

  final header = {'Content-type': 'application/json'};

  getMessage(ChatMessage m) async {
    typing.add(botChat);
    allMessages.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(messgaeUrl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);

        ChatMessage m1 = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: botChat,
            createdAt: DateTime.now());
        print(result['candidates'][0]['content']['parts'][0]['text']);

        allMessages.insert(0, m1);
      } else {
        print('error');
      }
    }).catchError((e) {});
    typing.remove(botChat);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: "I'm here to help you".text.color(theme.primaryColor).make(),
      ),
      body: DashChat(
          typingUsers: typing,
          currentUser: myself,
          onSend: (ChatMessage m) {
            getMessage(m);
          },
          messages: allMessages),
    );
  }
}
