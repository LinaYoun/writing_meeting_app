import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article.dart';
import '../models/author.dart';

// Feed tab state
enum FeedTab { following, interests }

class FeedTabNotifier extends Notifier<FeedTab> {
  @override
  FeedTab build() => FeedTab.following;

  void setTab(FeedTab tab) => state = tab;
}

final feedTabProvider = NotifierProvider<FeedTabNotifier, FeedTab>(FeedTabNotifier.new);

// Navigation index
class NavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final navIndexProvider = NotifierProvider<NavIndexNotifier, int>(NavIndexNotifier.new);

// Articles state notifier
class ArticlesNotifier extends Notifier<List<Article>> {
  @override
  List<Article> build() => _sampleFollowingArticles;

  void toggleLike(String articleId) {
    state = state.map((article) {
      if (article.id == articleId) {
        return article.copyWith(
          isLiked: !article.isLiked,
          likeCount: article.isLiked
              ? article.likeCount - 1
              : article.likeCount + 1,
        );
      }
      return article;
    }).toList();
  }

  void toggleBookmark(String articleId) {
    state = state.map((article) {
      if (article.id == articleId) {
        return article.copyWith(isBookmarked: !article.isBookmarked);
      }
      return article;
    }).toList();
  }

  void updateReadingProgress(String articleId) {
    state = state.map((article) {
      if (article.id == articleId && article.readingProgress != null) {
        final newProgress = (article.readingProgress! + 0.1).clamp(0.0, 1.0);
        final newMinutes = ((1 - newProgress) * 10).round();
        return article.copyWith(
          readingProgress: newProgress,
          minutesLeft: newMinutes,
        );
      }
      return article;
    }).toList();
  }

  void switchTab(FeedTab tab) {
    if (tab == FeedTab.following) {
      state = _sampleFollowingArticles;
    } else {
      state = _sampleInterestsArticles;
    }
  }
}

final articlesProvider =
    NotifierProvider<ArticlesNotifier, List<Article>>(ArticlesNotifier.new);

// Sample data - Following tab
final _sampleFollowingArticles = [
  Article(
    id: '1',
    author: const Author(
      id: 'a1',
      name: 'Min-seo Kim',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuARydCpeGqtrW97Dw1L0aPqngWjRdClSMZlz4k0C1juTBiXlbtuojJulEozWEbxZuFm20o_5Gk2GP6va1AMYNDMyxi_Sdx4wYtOZNgZoUtq8MDvsaYHHrPLdQsOPW8aEc0zDX4WYK-wrHqzmYG-rEJbLSqnhzu8QBAS4SFsLzcNvbiJArprlqBNoogSgYPawMhwClYEbqDvDDMUgkFzulOp_4t0v-5tDznXxv1frOEHknPhuAyMXXwhwPxE-rs-kMXwvS1INyRpxwQ',
      isVerified: true,
    ),
    title: 'The Art of Quiet Observation',
    snippet:
        'In the heart of a bustling metropolis, there exists a brief window of time where the city breathes in silence. I found myself wandering through the narrow alleys of Bukchon, capturing the essence of morning light as it hit the Hanok rooftops...',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD4y8KYPAcsnZQ_O1ld_ugo7WdT-hcARsqpi45VoaPpLYDJz0Ra410qM0ALDjRUQcw1HbY_8f78W84zr2MD1422BN1e3NxdA1Bro0u-vfOJ1fin2-5L-DmhZKQfzKJ6Aux43pkqmBt1ksNgEuXLEjBS3X-L5CW4kTFoM5yKcwztKdqxbs2vjZqPi9VwzYuYIhb-M0XbEUcPLjU5LKtLgFMkyfUsrCg6Dxmu751xLVumrIP_PKl8Lf93SnX46lJnDuXyEWrUNOMTs18',
    timeAgo: '2 hours ago',
    source: 'Naver Cafe: Literary Seoul',
    likeCount: 128,
    commentCount: 24,
    isLiked: false,
    type: ArticleType.standard,
  ),
  Article(
    id: '2',
    author: const Author(
      id: 'a2',
      name: 'Jun-ho Lee',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArIcwPb2Q-sHLvxYfdx01KPDyFv1YdkigCbMwXaDbRpKYLWRdF_jg1PgIQknUrzQcaimc88-3OVf3h64H6sFVxyjX6f_tdnp9NRKo6wVooBQIZ-h4SydxsBZgXOLr1LrSNPWRcjl3STzkROD4buzcDX9EO-JWYxvcM1MQFirrrNvDrpq4EpZU0b7sPDv8CTisqV1aSGDE7YMHlOoD-uqN456OMPr-BYiFo2_OgFrcJ5M9UTyRJiWfwJ0JzjQZUrHDRmW6pCftdBPI',
      isVerified: true,
    ),
    title: 'Why We Write Alone',
    snippet:
        'Solitude is not loneliness; it is the space where the soul speaks. For an essayist, the blank page is a companion that demands honesty. When we retreat into our quiet corners, we are not hiding from the world...',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCdQ0a-2vgUudNW7x9xEnmec2oZpnJIYuXqeEuQ4R3NOhbucIKhrdBz_BF62Y_Frt-_kME31vAKAL6FWfA-Ln0osq24J902JsnhFf1rmlSK84WTCioMczv9jNaDtj0Hp0wZ2yqT1RzROMxHHCFzBkQ_NWt-8KXnAaULu1vWtNvaVVofrGYRDRbX8zl7hwfraAa6_6n5Ay_NTEUM7r851xHoM4LYOI9TViYJ4KGhqH0gWSNeey-1s6BEn4B9xeXhkUrqh8na-ski9vo',
    timeAgo: '5 hours ago',
    source: 'Naver Cafe: Philosophy Daily',
    likeCount: 452,
    commentCount: 89,
    isLiked: true,
    type: ArticleType.inProgress,
    readingProgress: 0.33,
    minutesLeft: 3,
  ),
  Article(
    id: '3',
    author: const Author(
      id: 'a3',
      name: 'Elena Rossi',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDhVtya3vpRT0q9XDuDUXi8yt4WEbql4t0ipWgvz9yw9Jkrtj9oIRJpYaoaIxqkF_cgncrhjjQSqSFDEnlAulxVpQeg_1swjQeSs6GPRRfCRxSqB_7JPufOY9HxJRY22HTpCZ7qo325jaJzv2YAGdOFQ7YM9GSSFdTyobVj7YQ8v8U0Z4cu-OnTXx8vmwbAJ94-9Py5TGfSLHmXHaU6RLYh7zTK_HZJXFWUJTrk3S6lqeKO1NnNpkEqs7gpyu33F_fQLdQJ01tjxvs',
      isVerified: false,
    ),
    title: 'Alpine Echoes',
    snippet:
        'The air at three thousand meters is different. It\'s thin, cold, and carries the scent of ancient ice. In Switzerland, I learned that distance isn\'t measured in kilometers, but in the echoes of the bells...',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDWYeZTTb0Owo2ywGar-JOiQzUidJ1xnyYz-UwbAOUjpPHOdksDIfVLmYg0hqD4sIWWt_hvYqKfU3IioCI7lnd8IBV4sBwOYRryys_whjWuaeYjtermtHRXrnpCurRU9MTgH0QegCuS6pVU-avD_OsICHfWduNJD2R2w61QHwV9SNoAFI_e1rqSlv9ucWCfzxbp94jnyv1oF45oahrvJiLEprtjUzMCmRnALBTI59XK3OAqo7mEj0V-1vRJ6TfNFEQKEp-HlfTIEes',
    timeAgo: '1 day ago',
    source: 'Travel Essays',
    likeCount: 89,
    commentCount: 12,
    isLiked: false,
    isBookmarked: false,
    type: ArticleType.recommended,
    hashtag: '#TRAVEL_MEMOIR',
    recommendedReason: 'Recommended for you',
  ),
];

// Sample data - Interests tab
final _sampleInterestsArticles = [
  Article(
    id: '4',
    author: const Author(
      id: 'a4',
      name: 'Soo-jin Park',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuARydCpeGqtrW97Dw1L0aPqngWjRdClSMZlz4k0C1juTBiXlbtuojJulEozWEbxZuFm20o_5Gk2GP6va1AMYNDMyxi_Sdx4wYtOZNgZoUtq8MDvsaYHHrPLdQsOPW8aEc0zDX4WYK-wrHqzmYG-rEJbLSqnhzu8QBAS4SFsLzcNvbiJArprlqBNoogSgYPawMhwClYEbqDvDDMUgkFzulOp_4t0v-5tDznXxv1frOEHknPhuAyMXXwhwPxE-rs-kMXwvS1INyRpxwQ',
      isVerified: true,
    ),
    title: 'Digital Minimalism in Seoul',
    snippet:
        'In a city that never sleeps, where neon lights compete with the moon, I discovered the art of disconnection. The journey began with a simple question: what if we turned off our phones for a week?...',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD4y8KYPAcsnZQ_O1ld_ugo7WdT-hcARsqpi45VoaPpLYDJz0Ra410qM0ALDjRUQcw1HbY_8f78W84zr2MD1422BN1e3NxdA1Bro0u-vfOJ1fin2-5L-DmhZKQfzKJ6Aux43pkqmBt1ksNgEuXLEjBS3X-L5CW4kTFoM5yKcwztKdqxbs2vjZqPi9VwzYuYIhb-M0XbEUcPLjU5LKtLgFMkyfUsrCg6Dxmu751xLVumrIP_PKl8Lf93SnX46lJnDuXyEWrUNOMTs18',
    timeAgo: '3 hours ago',
    source: 'Naver Cafe: Tech & Life',
    likeCount: 234,
    commentCount: 45,
    isLiked: false,
    type: ArticleType.standard,
  ),
  Article(
    id: '5',
    author: const Author(
      id: 'a5',
      name: 'Hyun-woo Choi',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuArIcwPb2Q-sHLvxYfdx01KPDyFv1YdkigCbMwXaDbRpKYLWRdF_jg1PgIQknUrzQcaimc88-3OVf3h64H6sFVxyjX6f_tdnp9NRKo6wVooBQIZ-h4SydxsBZgXOLr1LrSNPWRcjl3STzkROD4buzcDX9EO-JWYxvcM1MQFirrrNvDrpq4EpZU0b7sPDv8CTisqV1aSGDE7YMHlOoD-uqN456OMPr-BYiFo2_OgFrcJ5M9UTyRJiWfwJ0JzjQZUrHDRmW6pCftdBPI',
      isVerified: true,
    ),
    title: 'The Coffee Shop Writer',
    snippet:
        'Every morning at 7 AM, I take my seat by the window. The same table, the same americano, the same blank notebook. This ritual has become my anchor in a sea of creative uncertainty...',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCdQ0a-2vgUudNW7x9xEnmec2oZpnJIYuXqeEuQ4R3NOhbucIKhrdBz_BF62Y_Frt-_kME31vAKAL6FWfA-Ln0osq24J902JsnhFf1rmlSK84WTCioMczv9jNaDtj0Hp0wZ2yqT1RzROMxHHCFzBkQ_NWt-8KXnAaULu1vWtNvaVVofrGYRDRbX8zl7hwfraAa6_6n5Ay_NTEUM7r851xHoM4LYOI9TViYJ4KGhqH0gWSNeey-1s6BEn4B9xeXhkUrqh8na-ski9vo',
    timeAgo: '8 hours ago',
    source: 'Naver Cafe: Writers Guild',
    likeCount: 567,
    commentCount: 102,
    isLiked: false,
    type: ArticleType.standard,
  ),
];
