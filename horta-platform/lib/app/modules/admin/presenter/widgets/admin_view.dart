import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubits/admin_cubit.dart';
import 'admin_page_header.dart';
import 'admin_empty_state.dart';
import 'request_card.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) => RefreshIndicator(
          onRefresh: cubit.load,
          color: const Color(0xFF10B981),
          child: CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.all(24),
                sliver: SliverToBoxAdapter(child: AdminPageHeader()),
              ),
              switch (state) {
                AdminLoading() => const SliverFillRemaining(
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF10B981))),
                  ),
                AdminError(:final message) => SliverFillRemaining(
                    child: Center(
                        child: Text(message,
                            style: TextStyle(
                                color: HortaTheme.textSecondary))),
                  ),
                AdminLoaded(:final requests) when requests.isEmpty =>
                  const SliverFillRemaining(child: AdminEmptyState()),
                AdminLoaded(:final requests) => SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: RequestCard(
                            request: requests[i],
                            onApprove: () =>
                                _confirmApprove(context, cubit, requests[i].id),
                            onReject: () => cubit.reject(requests[i].id),
                            onDelete: () =>
                                _confirmDelete(context, cubit, requests[i].id),
                          ),
                        ),
                        childCount: requests.length,
                      ),
                    ),
                  ),
              },
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmApprove(
      BuildContext context, AdminCubit cubit, String id) async {
    cubit.approve(id);
  }

  Future<void> _confirmDelete(
      BuildContext context, AdminCubit cubit, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF050510),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('admin.delete_confirm_title'.tr(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900)),
        content: Text('admin.delete_confirm_body'.tr(),
            style: const TextStyle(color: Color(0xFF64748B))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('common.cancel'.tr(),
                style: const TextStyle(color: Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('common.delete'.tr(),
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) cubit.delete(id);
  }
}
