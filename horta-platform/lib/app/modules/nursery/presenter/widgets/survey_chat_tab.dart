import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/nursery_datasource.dart';
import '../../domain/entities/survey.dart';
import '../../domain/entities/survey_response.dart';

class _ChatMsg {
  final String role;
  final String text;
  const _ChatMsg({required this.role, required this.text});
}

/// Mirrors React's SurveyChat.tsx:
/// - Per-survey AI chat
/// - Clear button (trash icon)
/// - Suggestion chips on empty state
/// - Markdown replies
/// - Bouncing 3-dot typing indicator
class SurveyChatTab extends StatefulWidget {
  final Survey survey;
  final List<SurveyResponse> responses;

  const SurveyChatTab(
      {super.key, required this.survey, required this.responses});

  @override
  State<SurveyChatTab> createState() => _SurveyChatTabState();
}

class _SurveyChatTabState extends State<SurveyChatTab>
    with SingleTickerProviderStateMixin {
  final List<_ChatMsg> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _loading = false;

  static const _suggestions = [
    'What are the top 3 technologies used?',
    'Any significant trend in productivity?',
    'Which country has the best results?',
  ];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
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
      _messages.add(_ChatMsg(role: 'user', text: text.trim()));
      _loading = true;
    });
    _scrollToBottom();

    try {
      final history = _messages
          .take(_messages.length - 1)
          .map((m) => {'role': m.role, 'parts': m.text})
          .toList();

      final reply = await GetIt.I<NurseryDatasource>().chatWithSurvey(
        surveyId: widget.survey.id,
        history: history,
        message: text.trim(),
        lang: context.locale.languageCode,
      );
      setState(() => _messages.add(_ChatMsg(role: 'model', text: reply)));
    } catch (_) {
      setState(() => _messages
          .add(_ChatMsg(role: 'model', text: 'survey.chat_error'.tr())));
    } finally {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            border: Border(
                bottom:
                    BorderSide(color: Colors.white.withValues(alpha: 0.06))),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('survey.ai_bot'.tr(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2)),
                  Text('survey.ask_data'.tr().toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2)),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _messages.clear()),
                icon: const Icon(Icons.delete_outline,
                    color: Color(0xFF64748B), size: 20),
                tooltip: 'survey.clear_chat'.tr(),
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: _messages.isEmpty
              ? _EmptyState(
                  suggestions: _suggestions,
                  onSelect: (s) {
                    _controller.text = s;
                    _send(s);
                  })
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length + (_loading ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == _messages.length) {
                      return const _TypingBubble();
                    }
                    return _Bubble(msg: _messages[i]);
                  },
                ),
        ),

        // Input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _send,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'survey.chat_hint'.tr(),
                        hintStyle: const TextStyle(
                            color: Colors.white24, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.03),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _send(_controller.text),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: _loading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.send,
                              color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'survey.ai_disclaimer'.tr().toUpperCase(),
                style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }
}

class _EmptyState extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String) onSelect;
  const _EmptyState({required this.suggestions, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white24, size: 32),
          ),
          const SizedBox(height: 12),
          Text('survey.chat_welcome'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 6),
          Text('survey.chat_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 11)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: suggestions
                .map((q) => GestureDetector(
                      onTap: () => onSelect(q),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF4F46E5).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: const Color(0xFF4F46E5)
                                  .withValues(alpha: 0.2)),
                        ),
                        child: Text(q,
                            style: const TextStyle(
                                color: Color(0xFF818CF8),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1)),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _ChatMsg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 18),
            ),
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
                  ? Text(msg.text,
                      style: const TextStyle(color: Colors.white, fontSize: 13))
                  : MarkdownBody(
                      data: msg.text,
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
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.person, color: Colors.white38, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(8)),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final t = (_ctrl.value - i * 0.15).clamp(0.0, 1.0);
                  final bounce = t < 0.5 ? t * 2 : 2 - t * 2;
                  return Transform.translate(
                    offset: Offset(0, -5 * bounce),
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
    _ctrl.dispose();
    super.dispose();
  }
}
