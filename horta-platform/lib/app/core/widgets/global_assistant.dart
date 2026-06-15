import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../network/api_service.dart';

class ChatMessage {
  final String role; // 'user' | 'model'
  final String text;
  const ChatMessage({required this.role, required this.text});
}

/// Floating assistant button + slide-up chat panel.
/// Mirrors React's GlobalAssistant.tsx:
/// - indigo FAB with pulse badge
/// - 380×520 chat card
/// - suggestion chips on empty state
/// - Markdown rendering for bot replies
/// - Animated typing indicator (3 bouncing dots)
class GlobalAssistant extends StatefulWidget {
  final List<Map<String, String>> surveysMetadata;

  const GlobalAssistant({super.key, this.surveysMetadata = const []});

  @override
  State<GlobalAssistant> createState() => _GlobalAssistantState();
}

class _GlobalAssistantState extends State<GlobalAssistant>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;

  List<String> get _suggestions => [
        'lab.suggestion_surveys'.tr(),
        'lab.suggestion_contribute'.tr(),
        'lab.suggestion_trends'.tr(),
      ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _loading) return;
    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', text: text.trim()));
      _loading = true;
    });
    _scrollToBottom();

    try {
      final history = _messages
          .where((m) => m != _messages.last)
          .map((m) => {'role': m.role, 'parts': m.text})
          .toList();
      final res = await GetIt.I<ApiService>().client.post('/api/v1/ai/chat', data: {
        'surveys': widget.surveysMetadata,
        'history': history,
        'message': text.trim(),
        'lang': context.locale.languageCode,
      });
      final reply = res.data['reply'] as String? ?? '';
      setState(() => _messages.add(ChatMessage(role: 'model', text: reply)));
    } catch (_) {
      setState(() => _messages
          .add(ChatMessage(role: 'model', text: 'survey.chat_error'.tr())));
    } finally {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Chat panel
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _isOpen
              ? Align(
                  key: const ValueKey('panel'),
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80, right: 0),
                    child: _ChatPanel(
                      messages: _messages,
                      loading: _loading,
                      controller: _controller,
                      scrollController: _scrollController,
                      suggestions: _suggestions,
                      onSend: _send,
                      onSuggestion: (s) {
                        _controller.text = s;
                      },
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('hidden')),
        ),

        // FAB
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(
                  child: Icon(
                    _isOpen ? Icons.close : Icons.chat_bubble,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (!_isOpen)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF10B981), width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// ─── Chat Panel ─────────────────────────────────────────────────────────────

class _ChatPanel extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool loading;
  final TextEditingController controller;
  final ScrollController scrollController;
  final List<String> suggestions;
  final void Function(String) onSend;
  final void Function(String) onSuggestion;

  const _ChatPanel({
    required this.messages,
    required this.loading,
    required this.controller,
    required this.scrollController,
    required this.suggestions,
    required this.onSend,
    required this.onSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 380,
        height: 520,
        decoration: BoxDecoration(
          color: const Color(0xFF020210),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
              blurRadius: 40,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF3730A3)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('survey.ai_bot'.tr().toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2)),
                      const Text('ACTIVE & INTELLIGENCE',
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5)),
                    ],
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: messages.isEmpty
                  ? _EmptyState(
                      suggestions: suggestions, onSelect: onSuggestion)
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length + (loading ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == messages.length) {
                          return const _TypingIndicator();
                        }
                        final m = messages[i];
                        return _MessageBubble(message: m);
                      },
                    ),
            ),

            // Input
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: onSend,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'lab.chat_hint'.tr(),
                        hintStyle: const TextStyle(
                            color: Colors.white30, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onSend(controller.text),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: loading
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send,
                              color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String) onSelect;

  const _EmptyState({required this.suggestions, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child:
                const Icon(Icons.smart_toy, color: Color(0xFF4F46E5), size: 24),
          ),
          const SizedBox(height: 12),
          Text('lab.chat_welcome'.tr(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 6),
          Text('lab.chat_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 11)),
          const SizedBox(height: 20),
          ...suggestions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => onSelect(q),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              const Color(0xFF4F46E5).withValues(alpha: 0.15)),
                    ),
                    child: Text(q,
                        style: const TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isUser ? 12 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 12),
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
                            height: 1.5),
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
            const SizedBox(width: 8),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.person, color: Colors.white54, size: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(6)),
            child: const Center(
                child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final offset = (_controller.value - i * 0.15).clamp(0.0, 1.0);
                  final bounce =
                      (offset < 0.5) ? offset * 2 : (1 - (offset - 0.5) * 2);
                  return Transform.translate(
                    offset: Offset(0, -4 * bounce),
                    child: Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(
                          color: Color(0xFF4F46E5), shape: BoxShape.circle),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
