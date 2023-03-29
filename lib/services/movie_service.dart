import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/api.dart';
import 'package:movies_db/models/movie.dart';
import 'package:movies_db/providers/client_provider.dart';

final movieService =
    Provider((ref) => MovieService(ref.watch(clienntProvider)));

class MovieService {
  final Dio dio;
  MovieService(this.dio);

  Future<Either<String, List<Movie>>> getData(
      {required String apiPath, required int page}) async {
    try {
      final response = await dio.get(
        apiPath,
        queryParameters: {
          'api_key': Api.apiKey,
          'page': page,
        },
      );
      final extractData = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return Right(extractData);
    } on DioError catch (err, s) {
      // return err.message;
      // print(err.type);
      // print(err.response!.statusCode);
      //print(stack);
      return Left(err.toString());
    }
  }

  Future<Either<String, List<Movie>>> searchMovie(String q) async {
    try {
      final response = await dio.get(
        Api.searchMovie,
        queryParameters: {
          'api_key': Api.apiKey,
          'page': 1,
          'query': q,
        },
      );
      final extractData = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return Right(extractData);
    } on DioError catch (err, s) {
      // return err.message;
      // print(err.type);
      // print(err.response!.statusCode);
      //print(stack);
      return Left(err.toString());
    }
  }
}
