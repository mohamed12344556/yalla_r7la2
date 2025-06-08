import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../cache/shared_pref_helper.dart';
import 'api_constants.dart';

class DioFactory {
  static Dio? _dio;

  static Dio getDio({bool withAuth = true}) {
    if (_dio == null) {
      _dio = Dio();
      _dio!.options.baseUrl = ApiConstants.baseUrl;

      _addDioHeader();
      _addInterceptor();
      return _dio!;
    }
    return _dio!;
  }

  static void _addDioHeader() async {
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.token);

    _dio!.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    // _dio!.options.connectTimeout = const Duration(seconds: 30);
    // _dio!.options.receiveTimeout = const Duration(seconds: 30);
  }

  static void _addInterceptor() {
    _dio!.interceptors.add(
      PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Add auth interceptor to handle token updates
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Update token for each request
          final token = await SharedPrefHelper.getSecuredString(
            SharedPrefKeys.token,
          );
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == 401) {
            // Clear stored data and redirect to login
            await SharedPrefHelper.clearAllData();
            await SharedPrefHelper.clearAllSecuredData();
            // You might want to navigate to login screen here
            // Navigator.pushReplacementNamed(context, Routes.login);
          }
          handler.next(error);
        },
      ),
    );
  }

  static void setAuthHeader(String accessToken) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.token, accessToken);
    _dio?.options.headers['Authorization'] = 'Bearer $accessToken';
  }

  static void clearAuthHeader() async {
    await SharedPrefHelper.removeData(SharedPrefKeys.token);
    _dio?.options.headers.remove('Authorization');
  }
}
