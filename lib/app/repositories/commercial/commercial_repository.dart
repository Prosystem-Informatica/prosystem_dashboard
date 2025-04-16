import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i_commercial_repository.dart';
import 'model/commercial_model.dart';


class CommercialRepository implements ICommercialRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

  CommercialRepository({
    required RestClient rest,
  }) : _rest = rest;


  @override
  Future<CommercialModel> commercial(String mesano, String idempresa) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var host = prefs.getString("host");
      var port = prefs.getString("port");

      var url =
          'http://$host:$port/datasnap/rest/TServerAPPnfe/Comercial/$mesano/$idempresa';

      print("URL > ${url}");
      Map<String, String> headers = {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=5, max=1000',
        'Accept-Enconding': 'gzip, deflate, br',
        'Accept': '*/*'
      };

      var response = await http.get(Uri.parse(url),headers: headers);

      print("Response do comercial > ${response.toString()}");

      var jsonData = jsonDecode(response.body);

      var res = await CommercialModel.fromJson(jsonData);

      print("RES DO COMERCIAL > ${res.toString()}");

      return res;
    } on FormatException catch (e) {
      log('Json Error: ${e.toString()}');
      throw CommercialModel();
    }catch (e, s) {
      log(e.toString());
      log(s.toString());

      return CommercialModel();
    }
  }

}
