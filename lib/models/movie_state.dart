import 'package:movies_db/models/movie.dart';

class MovieState {
  final bool isError;
  final bool isSuccess;
  final String errMessage;
  final bool isLoad;
  final List<Movie> movies;
  final int page;

  MovieState({
    required this.errMessage,
    required this.isSuccess,
    required this.isError,
    required this.movies,
    required this.isLoad,
    required this.page,
  });

  MovieState copyWith({
    bool? isError,
    bool? isSuccess,
    String? errMessage,
    bool? isLoad,
    List<Movie>? movies,
    int? page,
  }) {
    return MovieState(
      errMessage: errMessage ?? this.errMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
      isLoad: isLoad ?? this.isLoad,
      movies: movies ?? this.movies,
      page: page ?? this.page,
    );
  }

  factory MovieState.empty() {
    return MovieState(
      errMessage: '',
      isSuccess: false,
      isError: false,
      movies: [],
      isLoad: false,
      page: 1,
    );
  }
}
