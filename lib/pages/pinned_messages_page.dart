import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PinnedMessagesPage extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  const PinnedMessagesPage({required this.messages, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinned Messages'),
        backgroundColor: const Color(0xFF0A0B1F),
      ),
      backgroundColor: const Color(0xFF0A0B1F),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: msg['isUser'] == true ? Colors.blueAccent : const Color(0xFFCC5500),
              borderRadius: BorderRadius.circular(16),
            ),
            child: MarkdownBody(
              data: msg['text'],
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(p: const TextStyle(color: Colors.white)),
            ),
          );
        },
      ),
    );
  }
}
