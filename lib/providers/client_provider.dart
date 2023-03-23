import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_db/api.dart';

final clienntProvider = Provider((ref) {
  final options = BaseOptions(
    baseUrl: Api.baseUrl,
    // connectTimeout: Duration(seconds: 10),
    // receiveTimeout: Duration(seconds: 10),
  );

  return Dio(options);
});
