import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../cubits/lab_cubit.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _Avatar(isUser: false),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: isUser
                  ? Text(message.text,
                      style: const TextStyle(color: Colors.white, fontSize: 13))
                  : MarkdownBody(
                      data: message.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 13,
                            height: 1.6),
                        strong: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        code: const TextStyle(
                            color: Color(0xFF818CF8),
                            fontFamily: 'monospace',
                            fontSize: 12),
                      ),
                    ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            _Avatar(isUser: true),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.isUser});
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser
            ? Colors.white.withValues(alpha: 0.07)
            : const Color(0xFF4F46E5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        color: isUser ? Colors.white38 : Colors.white,
        size: 18,
      ),
    );
  }
}
