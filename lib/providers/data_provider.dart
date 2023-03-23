import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider =
    FutureProvider.family((ref, String id) => DataProvider.getData());

class DataProvider {
  static final dio = Dio();
  static Future getData() async {
    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/upcoming',
        queryParameters: {
          'api_key': 'd77cd48d9533347594188f857ed056b0',
        },
      );
      return response.data;
    } on DioError catch (err) {
      // return err.message;
      // print(err.type);
      // print(err.response!.statusCode);
      return err;
    }
  }
}
