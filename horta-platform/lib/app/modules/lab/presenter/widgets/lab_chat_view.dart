import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../cubits/lab_cubit.dart';
import 'chat_bubble.dart';
import 'chat_empty_state.dart';
import 'typing_bubble.dart';

class LabChatView extends StatefulWidget {
  const LabChatView({super.key, required this.state});

  final LabChatIdle state;

  @override
  State<LabChatView> createState() => _LabChatViewState();
}

class _LabChatViewState extends State<LabChatView> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(LabChatView old) {
    super.didUpdateWidget(old);
    if (widget.state.messages.length != old.state.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        }
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final cubit = context.read<LabChatCubit>();
    final suggestions = [
      'lab.suggestion_surveys'.tr(),
      'lab.suggestion_contribute'.tr(),
      'lab.suggestion_trends'.tr(),
    ];

    return Column(
      children: [
        Expanded(
          child: widget.state.messages.isEmpty
              ? ChatEmptyState(
                  suggestions: suggestions,
                  onSelect: (s) {
                    _ctrl.text = s;
                    cubit.send(s, lang);
                  },
                )
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(24),
                  itemCount: widget.state.messages.length +
                      (widget.state.isLoading ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == widget.state.messages.length) {
                      return const TypingBubble();
                    }
                    return ChatBubble(message: widget.state.messages[i]);
                  },
                ),
        ),
        _LabChatInput(
          controller: _ctrl,
          isLoading: widget.state.isLoading,
          onSend: (text) {
            _ctrl.clear();
            cubit.send(text, lang);
          },
        ),
      ],
    );
  }
}

class _LabChatInput extends StatelessWidget {
  const _LabChatInput({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final void Function(String) onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSend,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'lab.chat_hint'.tr(),
                hintStyle:
                    const TextStyle(color: Colors.white24, fontSize: 13),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
