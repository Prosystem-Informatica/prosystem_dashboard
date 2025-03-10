
import 'package:prosystem_dashboard/app/core/rest/rest_client_response.dart';

abstract class RestClient {
  RestClient auth();
  RestClient unAuth();

  Future<RestClientResponse<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
      });

  Future<RestClientResponse<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
      });
}