import 'package:flutter/material.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../domain/entities/survey_request.dart';
import 'action_btn.dart';
import 'status_badge.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
  });

  final SurveyRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isPending = request.status == 'pending';

    return BentoCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _CardHeader(request: request)),
              const SizedBox(width: 12),
              Row(mainAxisSize: MainAxisSize.min, children: [
                if (isPending) ...[
                  ActionBtn(
                    icon: Icons.check,
                    color: const Color(0xFF10B981),
                    onTap: onApprove,
                  ),
                  const SizedBox(width: 6),
                  ActionBtn(
                    icon: Icons.close,
                    color: const Color(0xFFF59E0B),
                    onTap: onReject,
                  ),
                  const SizedBox(width: 6),
                ],
                ActionBtn(
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    onTap: onDelete,
                    ghost: true),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Text(
              '"${request.description}"',
              style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.request});
  final SurveyRequest request;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Flexible(
            child: Text(request.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 10),
          StatusBadge(status: request.status),
        ]),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            _MetaItem(
                icon: Icons.email_outlined, label: request.requesterEmail),
            if (request.createdAt != null)
              _MetaItem(
                icon: Icons.schedule,
                label: _formatDate(request.createdAt!),
              ),
            if (request.suggestedCategory != null &&
                request.suggestedCategory!.isNotEmpty)
              _MetaItem(
                icon: Icons.label_outline,
                label: request.suggestedCategory!,
                color: const Color(0xFF818CF8),
              ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF64748B),
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    ]);
  }
}
