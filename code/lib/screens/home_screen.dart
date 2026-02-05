import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../models/article.dart';
import '../providers/feed_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/feed_toggle.dart';
import '../widgets/article_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final articles = ref.watch(articlesProvider);

    // 반응형 높이 계산
    final screenHeight = MediaQuery.of(context).size.height;
    final isCompact = screenHeight < 700;
    final headerHeight = isCompact ? 110.0 : 140.0;

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // Sticky header
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: headerHeight,
                collapsedHeight: headerHeight,
                toolbarHeight: headerHeight,
                backgroundColor: isDark
                    ? AppColors.backgroundDark.withValues(alpha: 0.8)
                    : AppColors.backgroundLight.withValues(alpha: 0.8),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.backgroundDark.withValues(alpha: 0.8)
                        : AppColors.backgroundLight.withValues(alpha: 0.8),
                    border: Border(
                      bottom: BorderSide(
                        color:
                            isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.srcOver,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppHeader(isCompact: isCompact),
                          FeedToggle(isCompact: isCompact),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Article list
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final article = articles[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 16 : 32,
                        ),
                        child: Opacity(
                          opacity: article.type == ArticleType.recommended
                              ? 0.8
                              : 1.0,
                          child: ArticleCard(article: article),
                        ),
                      );
                    },
                    childCount: articles.length,
                  ),
                ),
              ),
            ],
          ),
          // Bottom navigation bar
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(),
          ),
          // Floating write button
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingWriteButton(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Write feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
