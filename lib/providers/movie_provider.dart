import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/models/movie_state.dart';
import 'package:movies_db/services/movie_service.dart';

final movieProvider =
    StateNotifierProvider.family<MovieProvider, MovieState, String>(
        (ref, String api) => MovieProvider(
              MovieState.empty(),
              ref.watch(movieService),
              api,
            ));

class MovieProvider extends StateNotifier<MovieState> {
  final MovieService service;
  final String apiPath;

  MovieProvider(
    super.state,
    this.service,
    this.apiPath,
  ) {
    getData();
  }

  Future<void> getData() async {
    state = state.copyWith(
      errMessage: '',
      isSuccess: false,
      isError: false,
      isLoad: state.isLoadMore ? false : true,
    );
    final response = await service.getData(
      apiPath: apiPath,
      page: state.page,
    );
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

  void loadMore() async {
    state = state.copyWith(
      isError: false,
      isLoadMore: false,
      page: state.page + 1,
    );
    getData();
  }
}
