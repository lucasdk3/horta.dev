import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LabHeader extends StatelessWidget {
  const LabHeader({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('app.lab'.tr().toUpperCase(),
              style: const TextStyle(
                  color: Color(0xFF4F46E5),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4)),
          const SizedBox(height: 4),
          Text('lab.title'.tr(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5)),
          const SizedBox(height: 4),
          Text('lab.subtitle'.tr(),
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          const SizedBox(height: 20),
          LabTabBar(controller: tabController),
        ],
      ),
    );
  }
}

class LabTabBar extends StatelessWidget {
  const LabTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: const Color(0xFF4F46E5),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1),
        tabs: [
          Tab(
            icon: const Icon(Icons.auto_awesome, size: 16),
            text: 'lab.tab_insights'.tr().toUpperCase(),
          ),
          Tab(
            icon: const Icon(Icons.chat_bubble, size: 16),
            text: 'lab.tab_chat'.tr().toUpperCase(),
          ),
        ],
      ),
    );
  }
}
