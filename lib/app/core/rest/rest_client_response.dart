import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class RestClientResponse<T> {
  T? data;
  int? statusCode;
  RestClientResponse({
    this.data,
    this.statusCode,
  });

  factory RestClientResponse.fromHttp(http.Response response) {
    try{
      final res = jsonDecode(response.body);
      return RestClientResponse(
        data: res,
        statusCode: response.statusCode,
      );
    }on Exception catch(e){

      rethrow;
    }
  }
}