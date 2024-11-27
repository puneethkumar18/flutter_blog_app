import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: blog.topics
                  .map(
                    (topic) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Chip(
                        label: Text(topic),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Text(
            blog.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text('${calculateReadingTime(blog.content)} min ago')
        ],
      ),
    );
  }
}
