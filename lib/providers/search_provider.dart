import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movies_db/models/search_state.dart';
import 'package:movies_db/services/movie_service.dart';

final searchProvider =
    StateNotifierProvider<SearchProvider, SearchState>((ref) => SearchProvider(
          SearchState.empty(),
          ref.watch(movieService),
        ));

class SearchProvider extends StateNotifier<SearchState> {
  final MovieService service;

  SearchProvider(
    super.state,
    this.service,
  );

  Future<void> getSearch(String query) async {
    state = state.copyWith(
      errMessage: '',
      isSuccess: false,
      isError: false,
      isLoad: true,
    );
    final response = await service.searchMovie(query);
    response.fold((l) {
      state = state.copyWith(
        errMessage: l,
        isSuccess: false,
        movies: [],
        isError: true,
        isLoad: false,
      );
    }, (r) {
      state = state.copyWith(
        errMessage: '',
        isSuccess: true,
        movies: [...state.movies, ...r],
        isError: false,
        isLoad: false,
      );
    });
  }
}
