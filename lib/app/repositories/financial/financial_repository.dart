import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/repositories/financial/i_financial_repository.dart';
import 'package:prosystem_dashboard/app/repositories/financial/model/financial_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FinancialRepository implements IFinancialRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

   FinancialRepository({
    required RestClient rest,
  }) : _rest = rest;


  @override
  Future<FinancialModel> financial(String mesano, String idempresa) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var host = prefs.getString("host");
      var port = prefs.getString("port");

      var url =
          'http://$host:$port/datasnap/rest/TServerAPPnfe/Financeiro/$mesano/$idempresa';
      print("URL > ${url}");

      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      var res = await FinancialModel.fromJson(jsonData);

      return res;
    } catch (e) {
      log(e.toString());
      return FinancialModel();
    }
  }

}
