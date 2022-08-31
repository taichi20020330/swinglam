class Post {
  String postId;
  String userId;
  String imageUrl;
  String imageStoragePath;
  String caption;
  String locationString;
  double latitude;
  double longitude;
  DateTime PostDateTime;

//<editor-fold desc="Data Methods">

  Post({
    required this.postId,
    required this.userId,
    required this.imageUrl,
    required this.imageStoragePath,
    required this.caption,
    required this.locationString,
    required this.latitude,
    required this.longitude,
    required this.PostDateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          runtimeType == other.runtimeType &&
          postId == other.postId &&
          userId == other.userId &&
          imageUrl == other.imageUrl &&
          imageStoragePath == other.imageStoragePath &&
          caption == other.caption &&
          locationString == other.locationString &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          PostDateTime == other.PostDateTime);

  @override
  int get hashCode =>
      postId.hashCode ^
      userId.hashCode ^
      imageUrl.hashCode ^
      imageStoragePath.hashCode ^
      caption.hashCode ^
      locationString.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      PostDateTime.hashCode;

  @override
  String toString() {
    return 'Post{' +
        ' postId: $postId,' +
        ' userId: $userId,' +
        ' imageUrl: $imageUrl,' +
        ' imageStoragePath: $imageStoragePath,' +
        ' caption: $caption,' +
        ' locationString: $locationString,' +
        ' latitude: $latitude,' +
        ' longitude: $longitude,' +
        ' PostDateTime: $PostDateTime,' +
        '}';
  }

  Post copyWith({
    String? postId,
    String? userId,
    String? imageUrl,
    String? imageStoragePath,
    String? caption,
    String? locationString,
    double? latitude,
    double? longitude,
    DateTime? PostDateTime,
  }) {
    return Post(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      imageStoragePath: imageStoragePath ?? this.imageStoragePath,
      caption: caption ?? this.caption,
      locationString: locationString ?? this.locationString,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      PostDateTime: PostDateTime ?? this.PostDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': this.postId,
      'userId': this.userId,
      'imageUrl': this.imageUrl,
      'imageStoragePath': this.imageStoragePath,
      'caption': this.caption,
      'locationString': this.locationString,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'PostDateTime': this.PostDateTime.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'] as String,
      userId: map['userId'] as String,
      imageUrl: map['imageUrl'] as String,
      imageStoragePath: map['imageStoragePath'] as String,
      caption: map['caption'] as String,
      locationString: map['locationString'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      PostDateTime: DateTime.parse(map['PostDateTime'] as String),
    );
  }

//</editor-fold>
}