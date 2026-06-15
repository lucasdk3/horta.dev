import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/about_hero_header.dart';
import 'widgets/about_bento_grid.dart';

class AboutPage extends StatefulWidget {
  final String? section;
  const AboutPage({super.key, this.section});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _scrollController = ScrollController();
  final _contributeKey = GlobalKey();
  final _privacyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.section != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSection());
    }
  }

  void _scrollToSection() {
    GlobalKey? key;
    if (widget.section == 'contribute') key = _contributeKey;
    if (widget.section == 'privacy') key = _privacyKey;
    final ctx = key?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AboutHeroHeader(),
              const SizedBox(height: 48),
              AboutBentoGrid(
                contributeKey: _contributeKey,
                privacyKey: _privacyKey,
              ),
              const SizedBox(height: 80),
              Center(
                child: Text(
                  '${'app.title'.tr().toUpperCase()} © ${DateTime.now().year} • ${'about.footer_credits'.tr().toUpperCase()}',
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
