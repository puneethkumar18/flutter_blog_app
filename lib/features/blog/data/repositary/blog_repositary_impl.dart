import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/error/server_execptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_loacal_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositary/blog_repositary.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositaryImpl implements BlogRepositary {
  final BlogRemoteDataSource remoteDataSource;
  final BlogLoacalDataSource loacalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositaryImpl(
    this.remoteDataSource,
    this.connectionChecker,
    this.loacalDataSource,
  );
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterID,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure("No Internet Connection! "));
      }
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
      if (!await connectionChecker.isConnected) {
        final blogs = loacalDataSource.getAllLocalBlogs();
        return right(blogs);
      }
      final blogModels = await remoteDataSource.getAllBlogs();
      loacalDataSource.uploadLocalBlogs(blogs: blogModels);
      return right(blogModels);
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
