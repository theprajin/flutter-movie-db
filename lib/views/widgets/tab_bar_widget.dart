import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    return OfflineBuilder(
      child: Container(),
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return connected
            ? _buildConsumer(connected)
            : categoryType == CategoryType.Popular
                ? _buildConsumer(connected)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('No Connection'),
                    ],
                  );
      },
    );
  }

  Consumer _buildConsumer(bool connect) {
    return Consumer(
      builder: (context, ref, child) {
        final apiPath = categoryType == CategoryType.Popular
            ? Api.popularMovie
            : categoryType == CategoryType.Upcoming
                ? Api.upcomingMovie
                : Api.topRatedMovie;
        final movieData = ref.watch(movieProvider(apiPath));

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
            child: NotificationListener(
              onNotification: (ScrollEndNotification onNotification) {
                final before = onNotification.metrics.extentBefore;
                final max = onNotification.metrics.maxScrollExtent;
                if (before == max) {
                  if (connect) {
                    ref.read(movieProvider(apiPath).notifier).loadMore();
                  }
                }
                return true;
              },
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
                      if (connect) {
                        Get.to(() => DetailScreen(
                              movie: movie,
                            ));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Check your Internet Connection",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: CachedNetworkImage(
                      errorWidget: (c, s, d) =>
                          Image.asset('assets/images/mov.png'),
                      imageUrl: movie.posterPath,
                      // placeholder: (c, s) => const Center(
                      //   child: CircularProgressIndicator(),
                      // ),
                      placeholder: (context, url) => dualRing,
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
