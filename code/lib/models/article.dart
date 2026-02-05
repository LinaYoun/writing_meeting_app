import 'author.dart';

enum ArticleType {
  standard,    // Type A - Basic article
  inProgress,  // Type B - Reading in progress
  recommended, // Type C - Recommended article
}

class Article {
  final String id;
  final Author author;
  final String title;
  final String snippet;
  final String imageUrl;
  final String timeAgo;
  final String source;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isBookmarked;
  final ArticleType type;

  // For inProgress type
  final double? readingProgress;
  final int? minutesLeft;

  // For recommended type
  final String? hashtag;
  final String? recommendedReason;

  const Article({
    required this.id,
    required this.author,
    required this.title,
    required this.snippet,
    required this.imageUrl,
    required this.timeAgo,
    required this.source,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.type = ArticleType.standard,
    this.readingProgress,
    this.minutesLeft,
    this.hashtag,
    this.recommendedReason,
  });

  Article copyWith({
    String? id,
    Author? author,
    String? title,
    String? snippet,
    String? imageUrl,
    String? timeAgo,
    String? source,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isBookmarked,
    ArticleType? type,
    double? readingProgress,
    int? minutesLeft,
    String? hashtag,
    String? recommendedReason,
  }) {
    return Article(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      imageUrl: imageUrl ?? this.imageUrl,
      timeAgo: timeAgo ?? this.timeAgo,
      source: source ?? this.source,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      type: type ?? this.type,
      readingProgress: readingProgress ?? this.readingProgress,
      minutesLeft: minutesLeft ?? this.minutesLeft,
      hashtag: hashtag ?? this.hashtag,
      recommendedReason: recommendedReason ?? this.recommendedReason,
    );
  }
}
