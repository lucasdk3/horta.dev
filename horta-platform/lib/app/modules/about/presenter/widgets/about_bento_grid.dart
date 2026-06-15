import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/bento_card.dart';

class AboutBentoGrid extends StatelessWidget {
  const AboutBentoGrid({
    super.key,
    this.contributeKey,
    this.privacyKey,
  });

  final GlobalKey? contributeKey;
  final GlobalKey? privacyKey;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isTablet = width > 600;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _WatermarkedBentoCard(
          number: '01',
          accentColor: const Color(0xFF3B82F6),
          width: isDesktop ? (width - 64) * 0.65 : width - 48,
          height: 440,
          child: _OGapCard(),
        ),
        _WatermarkedBentoCard(
          number: '02',
          accentColor: const Color(0xFF10B981),
          width: isDesktop
              ? (width - 64) * 0.32
              : (isTablet ? (width - 64) * 0.48 : width - 48),
          height: 440,
          child: _ConceitoCard(),
        ),
        _WatermarkedBentoCard(
          number: '03',
          accentColor: const Color(0xFF10B981),
          width: isTablet ? (width - 64) * 0.48 : width - 48,
          height: 440,
          child: _CreatorCard(),
        ),
        _WatermarkedBentoCard(
          number: '04',
          accentColor: const Color(0xFFF97316),
          width: isTablet ? (width - 64) * 0.48 : width - 48,
          height: 440,
          child: _ProcessoCard(),
        ),
        _WatermarkedBentoCard(
          number: '05',
          accentColor: const Color(0xFF10B981),
          width: isTablet ? (width - 64) * 0.48 : width - 48,
          height: 300,
          backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
          borderColor: const Color(0xFF10B981).withValues(alpha: 0.2),
          child: _ObjetivoCard(),
        ),
        _WatermarkedBentoCard(
          key: contributeKey,
          number: '06',
          accentColor: const Color(0xFFEF4444),
          width: isTablet ? (width - 64) * 0.48 : width - 48,
          height: 300,
          child: _ContribuirCard(),
        ),
        _WatermarkedBentoCard(
          key: privacyKey,
          number: '07',
          accentColor: const Color(0xFFF59E0B),
          width: width - 48,
          height: 220,
          child: _PrivacyCard(),
        ),
      ],
    );
  }
}

// ─── Watermarked wrapper ─────────────────────────────────────────────────────

class _WatermarkedBentoCard extends StatelessWidget {
  const _WatermarkedBentoCard({
    super.key,
    required this.number,
    required this.accentColor,
    required this.child,
    required this.width,
    required this.height,
    this.backgroundColor,
    this.borderColor,
  });

  final String number;
  final Color accentColor;
  final Widget child;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: BentoCard(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.w900,
                  color: accentColor.withValues(alpha: 0.04),
                  height: 1,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

// ─── Section icon helper ─────────────────────────────────────────────────────

Widget _sectionIcon(IconData icon, Color color) {
  return Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
    ),
    child: Icon(icon, color: color, size: 24),
  );
}

// ─── Card contents ───────────────────────────────────────────────────────────

class _OGapCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _sectionIcon(Icons.eco, const Color(0xFF3B82F6)),
          const SizedBox(width: 16),
          Text('about.gap_title'.tr(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1)),
        ]),
        const SizedBox(height: 24),
        Expanded(
          child: Text('about.gap_body'.tr(),
              style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.7)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: const Border(
                left: BorderSide(color: Color(0xFF10B981), width: 4)),
          ),
          child: Text('about.gap_highlight'.tr(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14)),
        ),
      ],
    );
  }
}

class _ConceitoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionIcon(Icons.spa, const Color(0xFF10B981)),
        const SizedBox(height: 24),
        Text('about.concept_title'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1)),
        const SizedBox(height: 16),
        Expanded(
          child: Text('about.concept_body'.tr(),
              style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.7)),
        ),
      ],
    );
  }
}

class _CreatorCard extends StatelessWidget {
  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionIcon(Icons.forest, const Color(0xFF10B981)),
        const SizedBox(height: 24),
        Text('about.creator_name'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1)),
        const SizedBox(height: 4),
        Text('about.creator_role'.tr().toUpperCase(),
            style: const TextStyle(
                color: Color(0xFF10B981),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 4)),
        const SizedBox(height: 16),
        Expanded(
          child: Text('about.creator_bio'.tr(),
              style: const TextStyle(
                  color: Color(0xFF94A3B8), fontSize: 14, height: 1.7)),
        ),
        const Divider(color: Colors.white10, height: 32),
        Row(
          children: [
            _SocialButton(
              icon: Icons.link,
              label: 'LinkedIn',
              onTap: () => _launchUrl('https://linkedin.com/in/lucasbatista'),
            ),
            const SizedBox(width: 12),
            _SocialButton(
              icon: Icons.email,
              label: 'Email',
              onTap: () => _launchUrl('mailto:lucasbatista1996@gmail.com'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: Colors.white60),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2)),
        ]),
      ),
    );
  }
}

class _ProcessoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionIcon(Icons.message, const Color(0xFFF97316)),
        const SizedBox(height: 24),
        Text('about.process_title'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1)),
        const SizedBox(height: 16),
        Expanded(
          child: Text('about.process_body'.tr(),
              style: const TextStyle(
                  color: Color(0xFF94A3B8), fontSize: 15, height: 1.7)),
        ),
      ],
    );
  }
}

class _ObjetivoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionIcon(Icons.spa, const Color(0xFF10B981)),
        const SizedBox(height: 24),
        Text('about.objective_title'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1)),
        const SizedBox(height: 12),
        Expanded(
          child: Text('about.objective_body'.tr(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.6)),
        ),
      ],
    );
  }
}

class _ContribuirCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.water_drop, 'about.contribute_respond'.tr()),
      (Icons.chat, 'about.contribute_suggest'.tr()),
      (Icons.code, 'about.contribute_lab'.tr()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionIcon(Icons.local_florist, const Color(0xFFEF4444)),
        const SizedBox(height: 24),
        Text('about.contribute_title'.tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1)),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(children: [
                  Icon(item.$1, size: 14, color: const Color(0xFF10B981)),
                  const SizedBox(width: 12),
                  Text(item.$2.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3)),
                ]),
              ),
            )),
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      'about.privacy_item1'.tr(),
      'about.privacy_item2'.tr(),
      'about.privacy_item3'.tr(),
      'about.privacy_item4'.tr(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          _sectionIcon(Icons.shield, const Color(0xFFF59E0B)),
          const SizedBox(width: 16),
          Text('about.privacy_title'.tr().toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1)),
        ]),
        const SizedBox(height: 24),
        Wrap(
          spacing: 40,
          runSpacing: 12,
          children: items
              .map((text) => SizedBox(
                    width: 220,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 6, right: 10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(text,
                              style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 13,
                                  height: 1.6)),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
