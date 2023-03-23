import 'package:flutter/material.dart';
import 'package:movies_db/constants/enum_category.dart';
import 'package:movies_db/views/widgets/tab_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 77,
          elevation: 0,
          flexibleSpace: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 120,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Watch Now',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                      ))
                ],
              ),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Popular',
              ),
              Tab(
                text: 'Top Rated',
              ),
              Tab(
                text: 'Upcoming',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TabBarWidget(categoryType: CategoryType.Popular),
            TabBarWidget(categoryType: CategoryType.Top_Rated),
            TabBarWidget(categoryType: CategoryType.Upcoming),
          ],
        ),
      ),
    );
  }
}
