part of 'blog_bloc.dart';

@immutable
sealed class BlogBlocEvent {}

final class BlogUpload extends BlogBlocEvent {
  final String title;
  final String content;
  final String posterID;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.title,
    required this.content,
    required this.posterID,
    required this.image,
    required this.topics,
  });
}

final class BlogFetchAllBlogs extends BlogBlocEvent {}
