import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/survey.dart';

class SurveyCard extends StatefulWidget {
  const SurveyCard({
    super.key,
    required this.survey,
    required this.accent,
    required this.isFirst,
    required this.lang,
    required this.onTap,
  });

  final Survey survey;
  final Color accent;
  final bool isFirst;
  final String lang;
  final VoidCallback onTap;

  @override
  State<SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: _LightCard(
            accent: widget.accent,
            hovered: _hovered,
            child: _CardContent(widget: widget, hovered: _hovered),
          ),
        ),
      ),
    );
  }
}

class _LightCard extends StatelessWidget {
  const _LightCard({
    required this.accent,
    required this.hovered,
    required this.child,
  });

  final Color accent;
  final bool hovered;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: HortaTheme.darkCardBg(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HortaTheme.darkCardBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: hovered ? 0.18 : 0.1),
            blurRadius: hovered ? 32 : 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.widget, required this.hovered});

  final SurveyCard widget;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Watermark
        Stack(
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: Text(
                widget.survey.id.length >= 2
                    ? widget.survey.id.substring(0, 2).toUpperCase()
                    : '##',
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.w900,
                  color: widget.accent.withValues(alpha: hovered ? 0.06 : 0.03),
                  height: 1,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: widget.accent.withValues(alpha: 0.15)),
                      ),
                      child: Icon(Icons.spa, color: widget.accent, size: 24),
                    ),
                    Text(
                      widget.survey.category.toUpperCase(),
                      style: TextStyle(
                        color: widget.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.survey.title.get(widget.lang),
                  style: TextStyle(
                    color: HortaTheme.pageText(context),
                    fontSize: widget.isFirst ? 32 : 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.survey.description.get(widget.lang),
                  style: const TextStyle(
                      color: HortaTheme.textSecondary,
                      fontSize: 13,
                      height: 1.6),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          children: widget.survey.tags
                              .take(3)
                              .map((t) => Text(
                                    '#$t',
                                    style: TextStyle(
                                      color: widget.accent.withValues(alpha: 0.7),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NURTURING ECOSYSTEM',
                          style: TextStyle(
                            color: const Color(0xFF10B981).withValues(alpha: 0.5),
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text: 'https://horta.dev/s/${widget.survey.id}',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Link copied!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: widget.accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: widget.accent.withValues(alpha: 0.1)),
                        ),
                        child: Icon(Icons.water_drop_outlined,
                            color: widget.accent, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
