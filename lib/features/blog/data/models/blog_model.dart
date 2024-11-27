import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel(
      {required super.id,
      required super.posterID,
      required super.title,
      required super.content,
      required super.imageUrl,
      required super.topics,
      required super.updatedAt,
      super.posterName});

  BlogModel copyWith(
      {String? id,
      String? posterID,
      String? title,
      String? content,
      String? imageUrl,
      List<String>? topics,
      DateTime? updatedAt,
      String? posterName}) {
    return BlogModel(
      id: id ?? this.id,
      posterID: posterID ?? this.posterID,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'poster_id': posterID});
    result.addAll({'title': title});
    result.addAll({'content': content});
    result.addAll({'image_url': imageUrl});
    result.addAll({'topics': topics});
    result.addAll({'updated_at': updatedAt.toIso8601String()});

    return result;
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] ?? '',
      posterID: map['poster_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['image_url'] ?? '',
      topics: List<String>.from(map['topics']),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }
}
