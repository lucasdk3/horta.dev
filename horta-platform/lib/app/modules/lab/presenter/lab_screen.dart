import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_theme.dart';
import 'cubits/lab_cubit.dart';
import 'widgets/lab_header.dart';
import 'widgets/lab_insights_tab.dart';
import 'widgets/lab_chat_view.dart';

class LabScreen extends StatelessWidget {
  const LabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              GetIt.I<LabInsightsCubit>()..load(context.locale.languageCode),
        ),
        BlocProvider(create: (_) => GetIt.I<LabChatCubit>()),
      ],
      child: const _LabView(),
    );
  }
}

class _LabView extends StatefulWidget {
  const _LabView();

  @override
  State<_LabView> createState() => _LabViewState();
}

class _LabViewState extends State<_LabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HortaTheme.darkBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabHeader(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                LabInsightsTab(),
                _ChatTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabChatCubit, LabChatState>(
      builder: (context, state) =>
          LabChatView(state: state as LabChatIdle),
    );
  }
}
