import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../providers/feed_provider.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = ref.watch(navIndexProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.backgroundDark.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                filledIcon: Icons.home,
                label: 'Feed',
                isSelected: selectedIndex == 0,
                onTap: () => ref.read(navIndexProvider.notifier).setIndex(0),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.search,
                filledIcon: Icons.search,
                label: 'Explore',
                isSelected: selectedIndex == 1,
                onTap: () => ref.read(navIndexProvider.notifier).setIndex(1),
                isDark: isDark,
              ),
              // FAB placeholder
              const SizedBox(width: 48),
              _NavItem(
                icon: Icons.forum_outlined,
                filledIcon: Icons.forum,
                label: 'Cafe',
                isSelected: selectedIndex == 2,
                onTap: () => ref.read(navIndexProvider.notifier).setIndex(2),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.account_circle_outlined,
                filledIcon: Icons.account_circle,
                label: 'Profile',
                isSelected: selectedIndex == 3,
                onTap: () => ref.read(navIndexProvider.notifier).setIndex(3),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData filledIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.filledIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? filledIcon : icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingWriteButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingWriteButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Icons.edit_square,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
