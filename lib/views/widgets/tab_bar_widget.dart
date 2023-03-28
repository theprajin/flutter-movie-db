import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:movies_db/api.dart';
import 'package:movies_db/constants/const_widgets.dart';
import 'package:movies_db/constants/enums.dart';
import 'package:movies_db/providers/movie_provider.dart';
import 'package:movies_db/views/detail_screen.dart';

class TabBarWidget extends StatelessWidget {
  final CategoryType categoryType;
  final String pageKey;

  const TabBarWidget({
    super.key,
    required this.categoryType,
    required this.pageKey,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final movieData =
            ref.watch(movieProvider(categoryType == CategoryType.Popular
                ? Api.popularMovie
                : categoryType == CategoryType.Upcoming
                    ? Api.upcomingMovie
                    : Api.topRatedMovie));

        if (movieData.isLoad) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (movieData.isError) {
          return Center(
            child: Text(movieData.errMessage),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              key: PageStorageKey<String>(pageKey),
              itemCount: movieData.movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                final movie = movieData.movies[index];

                return InkWell(
                  splashColor: Colors.green,
                  onTap: () {
                    Get.to(() => DetailScreen(
                          movie: movie,
                        ));
                  },
                  child: CachedNetworkImage(
                    imageUrl: movie.posterPath,
                    // placeholder: (c, s) => const Center(
                    //   child: CircularProgressIndicator(),
                    // ),
                    placeholder: (context, url) => dualRing,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
