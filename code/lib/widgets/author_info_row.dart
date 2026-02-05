import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_colors.dart';
import '../models/author.dart';

class AuthorInfoRow extends StatelessWidget {
  final Author author;
  final String timeAgo;
  final String source;
  final bool showMoreButton;

  const AuthorInfoRow({
    super.key,
    required this.author,
    required this.timeAgo,
    required this.source,
    this.showMoreButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: author.avatarUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  child: Icon(
                    Icons.person,
                    color: AppColors.textSecondaryDark,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Author info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      author.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    if (author.isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: 14,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$timeAgo \u2022 $source',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          // More button
          if (showMoreButton)
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
