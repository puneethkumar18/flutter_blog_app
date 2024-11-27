import 'dart:io';

import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_bloc_event.dart';
part 'blog_bloc_state.dart';

class BlogBloc extends Bloc<BlogBlocEvent, BlogBlocState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _allBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _allBlogs = getAllBlogs,
        super(BlogBlocInitial()) {
    on<BlogBlocEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onBlogFetchAllBlogs);
  }

  void _onBlogFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogBlocState> emit) async {
    try {
      final res = await _allBlogs(NoParams());
      res.fold(
        (failure) => emit(BlogFailure(failure.message)),
        (blogs) => emit(
          BlogFetchAllBlogsSuccess(blogs),
        ),
      );
    } catch (e) {
      emit(BlogFailure(
        e.toString(),
      ));
    }
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogBlocState> emit) async {
    try {
      final res = await _uploadBlog(
        UploadBlogParams(
          image: event.image,
          title: event.title,
          content: event.content,
          posterID: event.posterID,
          topics: event.topics,
        ),
      );
      res.fold(
        (failure) => emit(BlogFailure(failure.message)),
        (blog) => emit(BlogSuccess()),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}
