import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  final bool isCompact;

  const AppHeader({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top row: Logo, title, badge, notification
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            isCompact ? 8 : 16,
            16,
            isCompact ? 4 : 8,
          ),
          child: Row(
            children: [
              // Logo
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              // Title
              Text(
                'Curation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const Spacer(),
              // Naver badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Naver',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.sync,
                      color: AppColors.primary,
                      size: 12,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Notification button
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
