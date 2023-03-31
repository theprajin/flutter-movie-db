import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:movies_db/constants/const_widgets.dart';
import 'package:movies_db/providers/search_provider.dart';
import 'package:movies_db/views/detail_screen.dart';

class SearchScreen extends StatelessWidget {
  final searchController = TextEditingController();
  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final data = ref.watch(searchProvider);
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    controller: searchController,
                    onFieldSubmitted: (val) {
                      ref.read(searchProvider.notifier).getSearch(val.trim());
                      searchController.clear();
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search Movie',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                  ),
                  Expanded(
                      child: data.isLoad
                          ? const Center(child: CircularProgressIndicator())
                          : data.isError
                              ? Center(child: Text(data.errMessage))
                              : GridView.builder(
                                  //key: PageStorageKey<String>(pageKey),
                                  itemCount: data.movies.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 2 / 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    final movie = data.movies[index];

                                    return InkWell(
                                      splashColor: Colors.green,
                                      onTap: () {
                                        Get.to(() => DetailScreen(
                                              movie: movie,
                                            ));
                                      },
                                      child: CachedNetworkImage(
                                        errorWidget: (c, s, a) => Image.asset(
                                            'assets/images/mov.png'),
                                        imageUrl: movie.posterPath,
                                        // placeholder: (c, s) => const Center(
                                        //   child: CircularProgressIndicator(),
                                        // ),
                                        placeholder: (context, url) => dualRing,
                                      ),
                                    );
                                  },
                                ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
