import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../models/article.dart';
import '../providers/feed_provider.dart';

class ArticleInteractions extends ConsumerWidget {
  final Article article;

  const ArticleInteractions({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Standard and InProgress articles
    if (article.type == ArticleType.standard ||
        article.type == ArticleType.inProgress) {
      return _StandardInteractions(
        article: article,
        isDark: isDark,
        onLike: () => ref.read(articlesProvider.notifier).toggleLike(article.id),
        onContinue: article.type == ArticleType.inProgress
            ? () => ref.read(articlesProvider.notifier).updateReadingProgress(article.id)
            : null,
      );
    }

    // Recommended article
    return _RecommendedInteractions(
      article: article,
      isDark: isDark,
      onBookmark: () =>
          ref.read(articlesProvider.notifier).toggleBookmark(article.id),
    );
  }
}

class _StandardInteractions extends StatelessWidget {
  final Article article;
  final bool isDark;
  final VoidCallback onLike;
  final VoidCallback? onContinue;

  const _StandardInteractions({
    required this.article,
    required this.isDark,
    required this.onLike,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: onLike,
            child: Row(
              children: [
                Icon(
                  article.isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: article.isLiked
                      ? AppColors.liked
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '${article.likeCount}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Comment button
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                '${article.commentCount}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Mood button
          Icon(
            Icons.mood,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            size: 20,
          ),
          const Spacer(),
          // Read/Continue button
          GestureDetector(
            onTap: onContinue ?? () {},
            child: Row(
              children: [
                Text(
                  article.type == ArticleType.inProgress ? 'CONTINUE' : 'READ FULL',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  article.type == ArticleType.inProgress
                      ? Icons.play_arrow
                      : Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedInteractions extends StatelessWidget {
  final Article article;
  final bool isDark;
  final VoidCallback onBookmark;

  const _RecommendedInteractions({
    required this.article,
    required this.isDark,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          // Small author avatar
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: DecorationImage(
                image: NetworkImage(article.author.avatarUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            article.author.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const Spacer(),
          // Bookmark button
          GestureDetector(
            onTap: onBookmark,
            child: Icon(
              article.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: article.isBookmarked
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Share button
          Icon(
            Icons.share_outlined,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            size: 18,
          ),
        ],
      ),
    );
  }
}
