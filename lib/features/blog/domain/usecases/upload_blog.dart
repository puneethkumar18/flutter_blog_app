import 'dart:io';

import 'package:fpdart/fpdart.dart';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositary/blog_repositary.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepositary blogRepositary;
  UploadBlog(this.blogRepositary);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepositary.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterID: params.posterID,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final File image;
  final String title;
  final String content;
  final String posterID;
  final List<String> topics;
  UploadBlogParams({
    required this.image,
    required this.title,
    required this.content,
    required this.posterID,
    required this.topics,
  });
}
