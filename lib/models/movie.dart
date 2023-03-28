class MovieData {
  final MovieDates? movieDates;
  final List<Movie> movie;

  MovieData({
    required this.movieDates,
    required this.movie,
  });
}

class MovieDates {
  final String maximum;
  final String minimum;

  MovieDates({
    required this.maximum,
    required this.minimum,
  });
}

class Movie {
  final int id;
  final String title;
  final String overview;
  final String backdropPath;
  final String posterPath;
  final String voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.backdropPath,
    required this.posterPath,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'],
      backdropPath: json['backdrop_path'] ?? '',
      posterPath:
          'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${json['poster_path']}',
      voteAverage: '${json['vote_average']}',
    );
  }

  @override
  String toString() {
    return 'Movie('
        'title: $title'
        ')';
  }
}
