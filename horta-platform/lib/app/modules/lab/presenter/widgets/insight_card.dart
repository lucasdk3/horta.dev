import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../../../core/widgets/bento_card.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.title,
    required this.summary,
    required this.isLoading,
    required this.onRefresh,
  });

  final String title;
  final String? summary;
  final bool isLoading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BentoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900)),
                ]),
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh,
                      color: Color(0xFF64748B), size: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const _SkeletonLoader()
            else if (summary != null)
              MarkdownBody(
                data: summary!,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                      color: Color(0xFFCBD5E1), fontSize: 13, height: 1.7),
                  h2: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900),
                  strong: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  code: const TextStyle(
                      color: Color(0xFF818CF8),
                      fontFamily: 'monospace',
                      fontSize: 12),
                ),
              )
            else
              const Text('—',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  const _SkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _bar(0.8),
      const SizedBox(height: 8),
      _bar(1.0),
      const SizedBox(height: 8),
      _bar(0.6),
    ]);
  }

  Widget _bar(double w) => FractionallySizedBox(
        widthFactor: w,
        alignment: Alignment.centerLeft,
        child: Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
}
