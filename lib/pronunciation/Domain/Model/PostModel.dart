class PostData {
  final int page;
  final int perPage;
  final int totalPages;
  final int totalPosts;

  PostData({
    required this.page,
    required this.perPage,
    required this.totalPages,
    required this.totalPosts,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      page: json['page'],
      perPage: json['per_page'],
      totalPages: json['total_pages'],
      totalPosts: json['total_posts'],
    );
  }
}

class Post {
  final String postId;
  final String postTitle;
  final String postContent;
  final String postLanguageName;
  final String aiReadingUrl;
  final String datePosted;

  Post({
    required this.postId,
    required this.postTitle,
    required this.postContent,
    required this.postLanguageName,
    required this.aiReadingUrl,
    required this.datePosted,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'],
      postTitle: json['post_title'],
      postContent: json['post_content'],
      postLanguageName: json['post_language_name'],
      aiReadingUrl: json['ai_reading'],
      datePosted: json['date_posted'],
    );
  }
}
