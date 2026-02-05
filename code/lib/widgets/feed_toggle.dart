import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../providers/feed_provider.dart';

class FeedToggle extends ConsumerWidget {
  final bool isCompact;

  const FeedToggle({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTab = ref.watch(feedTabProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isCompact ? 6 : 12,
      ),
      child: Container(
        height: isCompact ? 36 : 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.5)
              : AppColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: 'Following',
                isSelected: selectedTab == FeedTab.following,
                onTap: () {
                  ref.read(feedTabProvider.notifier).setTab(FeedTab.following);
                  ref.read(articlesProvider.notifier).switchTab(FeedTab.following);
                },
                isDark: isDark,
              ),
            ),
            Expanded(
              child: _ToggleButton(
                label: 'Interests',
                isSelected: selectedTab == FeedTab.interests,
                onTap: () {
                  ref.read(feedTabProvider.notifier).setTab(FeedTab.interests);
                  ref.read(articlesProvider.notifier).switchTab(FeedTab.interests);
                },
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _ToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.backgroundDark : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? (isDark ? Colors.white : AppColors.primary)
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }
}
