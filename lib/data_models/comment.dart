class Comment {
  String commentId;
  String commentUserId;
  String postId;
  String comment;
  DateTime commentDateTime;

//<editor-fold desc="Data Methods">

  Comment({
    required this.commentId,
    required this.commentUserId,
    required this.postId,
    required this.comment,
    required this.commentDateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          runtimeType == other.runtimeType &&
          commentId == other.commentId &&
          commentUserId == other.commentUserId &&
          postId == other.postId &&
          comment == other.comment &&
          commentDateTime == other.commentDateTime);

  @override
  int get hashCode =>
      commentId.hashCode ^
      commentUserId.hashCode ^
      postId.hashCode ^
      comment.hashCode ^
      commentDateTime.hashCode;

  @override
  String toString() {
    return 'Comment{' +
        ' commentId: $commentId,' +
        ' commentUserId: $commentUserId,' +
        ' postId: $postId,' +
        ' comment: $comment,' +
        ' commentDateTime: $commentDateTime,' +
        '}';
  }

  Comment copyWith({
    String? commentId,
    String? commentUserId,
    String? postId,
    String? comment,
    DateTime? commentDateTime,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      commentUserId: commentUserId ?? this.commentUserId,
      postId: postId ?? this.postId,
      comment: comment ?? this.comment,
      commentDateTime: commentDateTime ?? this.commentDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': this.commentId,
      'commentUserId': this.commentUserId,
      'postId': this.postId,
      'comment': this.comment,
      'commentDateTime': this.commentDateTime.toIso8601String()
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as String,
      commentUserId: map['commentUserId'] as String,
      postId: map['postId'] as String,
      comment: map['comment'] as String,
      commentDateTime: DateTime.parse(map['commentDateTime'] as String),
    );
  }

//</editor-fold>
}