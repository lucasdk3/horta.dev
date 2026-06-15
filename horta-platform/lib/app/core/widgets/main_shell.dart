import 'package:flutter/material.dart';
import 'horta_navbar.dart';
import 'global_assistant.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const HortaNavbar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: child),
              const HortaFooter(),
            ],
          ),
          const Positioned(
            right: 24,
            bottom: 56,
            child: GlobalAssistant(),
          ),
        ],
      ),
    );
  }

}
