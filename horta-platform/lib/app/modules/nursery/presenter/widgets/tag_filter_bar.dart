import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';

class TagFilterBar extends StatelessWidget {
  const TagFilterBar({
    super.key,
    required this.tags,
    required this.selected,
    required this.onSelect,
  });

  final List<String> tags;
  final String? selected;
  final void Function(String?) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: HortaTheme.containerBg(context),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: HortaTheme.containerBorder(context)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TagChip(
              label: 'nursery.entire_field'.tr(),
              selected: selected == null,
              onTap: () => onSelect(null),
            ),
            Container(
              width: 1,
              height: 20,
              color: HortaTheme.containerBorder(context),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            ...tags.map((t) => _TagChip(
                  label: t.toUpperCase(),
                  selected: selected == t,
                  isTag: true,
                  onTap: () => onSelect(selected == t ? null : t),
                )),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    this.isTag = false,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool isTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? HortaTheme.primaryEmerald : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : HortaTheme.pageText(context),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
