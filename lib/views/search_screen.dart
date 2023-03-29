import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/providers/search_provider.dart';

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
                    onFieldSubmitted: (value) {},
                    decoration: const InputDecoration(
                        hintText: 'Search Movie',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.movies.length,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
