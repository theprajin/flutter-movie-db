import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:movies_db/api.dart';
import 'package:movies_db/api_exceptions/api_exception.dart';
import 'package:movies_db/models/movie.dart';
import 'package:movies_db/providers/client_provider.dart';

final movieService =
    Provider((ref) => MovieService(ref.watch(clienntProvider)));

class MovieService {
  final Dio dio;
  MovieService(this.dio);

  final box = Hive.box<String>('movie');

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

      if (apiPath == Api.popularMovie) {
        final res = await dio.get(
          apiPath,
          queryParameters: {
            'api_key': Api.apiKey,
            'page': 1,
          },
        );

        box.put('popular', jsonEncode(res.data['results']));
      }

      final extractData = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return Right(extractData);
    } on DioError catch (err, s) {
      if (box.isNotEmpty && apiPath == Api.popularMovie) {
        final data = jsonDecode(box.get('popular')!);
        final extractData =
            (data as List).map((e) => Movie.fromJson(e)).toList();
        return Right(extractData);
      } else {
        return Left(DioException().getDioError(err));
      }
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
      if ((response.data['results'] as List).isEmpty) {
        return const Left('Nothing Found\n Try using another keyword');
      }
      final extractData = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return Right(extractData);
    } on DioError catch (err, s) {
      // return err.message;
      // print(err.type);
      // print(err.response!.statusCode);
      //print(stack);
      return Left(DioException().getDioError(err));
    }
  }
}
