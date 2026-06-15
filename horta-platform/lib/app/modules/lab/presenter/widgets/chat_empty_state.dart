import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  final List<String> suggestions;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4F46E5).withValues(alpha: 0.08),
              border: Border.all(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.15)),
            ),
            child:
                const Icon(Icons.smart_toy, color: Color(0xFF4F46E5), size: 32),
          ),
          const SizedBox(height: 16),
          Text('lab.chat_welcome'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 6),
          Text('lab.chat_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 24),
          ...suggestions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => onSelect(q),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color:
                              const Color(0xFF4F46E5).withValues(alpha: 0.15)),
                    ),
                    child: Text(q,
                        style: const TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
