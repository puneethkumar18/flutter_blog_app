import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/error/server_execptions.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositary/blog_repositary.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositaryImpl implements BlogRepositary {
  final BlogRemoteDataSource remoteDataSource;
  BlogRepositaryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterID,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterID: posterID,
        title: title,
        content: content,
        imageUrl: "",
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final supaBaseImegUrl = await remoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(imageUrl: supaBaseImegUrl);

      final blog = await remoteDataSource.uploadBlog(blogModel);
      return right(blog);
    } on ServerExecption catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogModels = await remoteDataSource.getAllBlogs();
      return right(blogModels);
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
