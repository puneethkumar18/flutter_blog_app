part of 'blog_bloc.dart';

@immutable
sealed class BlogBlocState {}

final class BlogBlocInitial extends BlogBlocState {}

final class BlogLoading extends BlogBlocState {}

final class BlogFailure extends BlogBlocState {
  final String error;
  BlogFailure(this.error);
}

final class BlogSuccess extends BlogBlocState {}

final class BlogFetchAllBlogsSuccess extends BlogBlocState {
  final List<Blog> blogs;
  BlogFetchAllBlogsSuccess(this.blogs);
}
