import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});
  static const name = "chatRoom";
  @override
  State<ChatRoom> createState() => _SocialState();
}

class _SocialState extends State<ChatRoom> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("Chat"),
              ),
              Tab(
                child: Text("Group"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text("data"),
            Text("Hello"),
          ],
        ),
      ),
    );
  }
}
