import 'dart:io';

import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'blog_bloc_event.dart';
part 'blog_bloc_state.dart';

class BlogBloc extends Bloc<BlogBlocEvent, BlogBlocState> {
  final UploadBlog _uploadBlog;
  BlogBloc({required UploadBlog uploadBlog})
      : _uploadBlog = uploadBlog,
        super(BlogBlocInitial()) {
    on<BlogBlocEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(
      (event, emit) => _onBlogUpload(event, emit),
    );
  }
  void _onBlogUpload(BlogUpload event, Emitter<BlogBlocState> emit) async {
    try {
      final res = await _uploadBlog.call(
        UploadBlogParams(
          image: event.image,
          title: event.title,
          content: event.content,
          posterID: event.posterID,
          topics: event.topics,
        ),
      );
      res.fold(
        (failure) => left(failure),
        (blog) => right(BlogSuccess()),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}
