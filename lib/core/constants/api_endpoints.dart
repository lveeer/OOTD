/// API端点定义
class ApiEndpoints {
  // 认证相关
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String sendSmsCode = '/auth/sms/send';
  static const String verifySmsCode = '/auth/sms/verify';

  // 用户相关
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String followUser = '/user/follow';
  static const String unfollowUser = '/user/unfollow';
  static const String getFollowers = '/user/followers';
  static const String getFollowing = '/user/following';

  // 帖子相关
  static const String feed = '/posts/feed';
  static const String postDetail = '/posts';
  static const String createPost = '/posts';
  static const String updatePost = '/posts';
  static const String deletePost = '/posts';
  static const String likePost = '/posts/like';
  static const String unlikePost = '/posts/unlike';
  static const String collectPost = '/posts/collect';
  static const String uncollectPost = '/posts/uncollect';
  static const String sharePost = '/posts/share';

  // 评论相关
  static const String comments = '/comments';
  static const String createComment = '/comments';
  static const String deleteComment = '/comments';
  static const String likeComment = '/comments/like';
  static const String unlikeComment = '/comments/unlike';

  // 商品相关
  static const String searchProduct = '/products/search';
  static const String productDetail = '/products';
  static const String convertLink = '/products/convert-link';
  static const String parseTaobaoPassword = '/products/parse-taobao-password';
  static const String getFavorites = '/products/favorites';
  static const String addFavorite = '/products/favorites';
  static const String removeFavorite = '/products/favorites';

  // 上传相关
  static const String uploadImage = '/upload/image';
  static const String uploadVideo = '/upload/video';

  // 钱包/佣金相关
  static const String wallet = '/wallet';
  static const String commissionHistory = '/wallet/commission';
  static const String withdraw = '/wallet/withdraw';
  static const String withdrawHistory = '/wallet/withdraw/history';

  // 数据分析
  static const String analytics = '/analytics';
  static const String gmvTrend = '/analytics/gmv-trend';
  static const String conversionFunnel = '/analytics/conversion-funnel';
  static const String categoryDistribution = '/analytics/category-distribution';

  // 草稿箱
  static const String drafts = '/drafts';
  static const String saveDraft = '/drafts';
  static const String deleteDraft = '/drafts';
}