import 'package:dio/dio.dart';
import 'package:shared_package/network/network_constant.dart';

class DioService {
  late Dio _dio;
  // final sharedPrefs = MySharePrefs.instance;

  DioService._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstant.productionUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        // headers: {
        //  Authorization": "Basic ZWNvbTplY29tQDEyMw==", "
        // },
        responseType: ResponseType.json,
        contentType: "application/json",
      ),
    )..interceptors.addAll([LogInterceptor()]);
  }

  static final instance = DioService._();

  Future<dynamic> get({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameter,
    Options? options,
  }) async {
    // final token = await sharedPrefs.gettingString(token_key);
    try {
      final res = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameter,
        options: options,
        // options: Options(headers: {
        //   "Authorization":
        //       token == null ? "Basic ZWNvbTplY29tQDEyMw==" : "Bearer $token",
        // }),
      );
      if (res.statusCode == 200) {
        return res.data;
      }
      throw ("Error server");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameter,
    String contentType = "application/json",
    Options? options,
  }) async {
    // final token = await sharedPrefs.gettingString(token_key);
    try {
      final res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameter,
        // options: Options(
        //   headers: {
        //     "Authorization":
        //         token == null ? "Basic ZWNvbTplY29tQDEyMw==" : "Bearer $token",
        //     "Content-Type": contentType,
        //   },
        // ),
        options: options,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return res.data;
      }
      throw ("erorr");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameter,
    Options? options,
  }) async {
    // final token = await sharedPrefs.gettingString(token_key);
    try {
      final res = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameter,
        options: options,
        // options: Options(
        //   headers: {
        //     "Authorization":
        //         token == null ? "Basic ZWNvbTplY29tQDEyMw==" : "Bearer $token",
        //   },
        // ),
      );
      if (res.statusCode == 200) {
        return res.data;
      }
      throw ("erorr");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put({
    required String path,
    dynamic data,
    Options? options,
  }) async {
    try {
      // final token = await sharedPrefs.gettingString(token_key);
      final res = await _dio.put(
        path,
        data: data,
        options: options,
        // options: Options(
        //   headers: {
        //     "Authorization": "Bearer ${token}",
        //   },
        // ),
      );
      if (res.statusCode == 200) {
        return res.data;
      }
      throw ("Error");
    } catch (e) {
      rethrow;
    }
  }
}
