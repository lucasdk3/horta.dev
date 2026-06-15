import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubits/garden_cubit.dart';
import 'profile_card.dart';
import 'stat_card.dart';
import 'badges_card.dart';
import 'admin_link_card.dart';

class GardenView extends StatefulWidget {
  const GardenView({super.key});

  @override
  State<GardenView> createState() => _GardenViewState();
}

class _GardenViewState extends State<GardenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressCtrl;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _progressAnim =
        CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GardenCubit, GardenState>(
      listener: (context, state) {
        if (state is GardenLoaded) {
          _progressCtrl.animateTo(state.profile.progressPercent);
        }
      },
      builder: (context, state) => switch (state) {
        GardenLoading() => const Center(
            child: CircularProgressIndicator(color: Color(0xFF10B981)),
          ),
        GardenError(:final message) => Center(
            child: Text(message,
                style: TextStyle(color: HortaTheme.textSecondary))),
        GardenLoaded(:final profile) => RefreshIndicator(
            onRefresh: context.read<GardenCubit>().load,
            color: const Color(0xFF10B981),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('garden.title'.tr().toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4)),
                  const SizedBox(height: 4),
                  Text(profile.displayName,
                      style: TextStyle(
                          color: HortaTheme.pageText(context),
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2)),
                  const SizedBox(height: 32),
                  ProfileCard(profile: profile, progressAnim: _progressAnim),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: StatCard(
                        label: 'garden.impact'.tr(),
                        value: 'Healthy',
                        icon: Icons.eco,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: 'garden.roots'.tr(),
                        value: '${profile.badges.length}',
                        icon: Icons.local_florist,
                        color: const Color(0xFFA855F7),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: 'garden.level'.tr(),
                        value: 'STG ${profile.level}',
                        icon: Icons.forest,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                  ]),
                  if (profile.badges.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    BadgesCard(badges: profile.badges),
                  ],
                  if (profile.isAdmin) ...[
                    const SizedBox(height: 16),
                    const AdminLinkCard(),
                  ],
                ],
              ),
            ),
          ),
      },
    );
  }
}
