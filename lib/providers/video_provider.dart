import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/api.dart';
import 'package:movies_db/providers/client_provider.dart';

final videoProvider = FutureProvider.family(((ref, int id) => VideoProvider(
      ref.watch(clienntProvider),
      id,
    ).getVideoId()));

class VideoProvider {
  final Dio _dio;
  final int id;

  VideoProvider(this._dio, this.id);

  Future<List<String>> getVideoId() async {
    try {
      final repsonse = await _dio.get(
        '/movie/$id/videos',
        queryParameters: {
          'api_key': Api.apiKey,
        },
      );
      //print(' the movie id is: $id');
      return (repsonse.data['results'] as List)
          .map((e) => e['key'] as String)
          .toList();
      // return repsonse.data['results'][0]['key'];
    } on DioError catch (err) {
      throw err.toString();
    }
  }
}
