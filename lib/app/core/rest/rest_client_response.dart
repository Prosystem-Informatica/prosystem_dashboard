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
      log('Falha ao fazer parsing do json', name: 'RestClientResponse.fromHttp', error: e);
      log('Response body: ${response.body}', name: 'RestClientResponse.fromHttp');
      print('Falha ao fazer parsing do json');
      print(response.body.toString());
      rethrow;
    }
  }
}