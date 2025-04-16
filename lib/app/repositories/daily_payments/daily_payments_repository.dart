import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i_daily_payments_repository.dart';
import 'models/daily_payments_model.dart';

class DailyPaymentsRepository implements IDailyPaymentsRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

   DailyPaymentsRepository({
    required RestClient rest,
  }) : _rest = rest;


  @override
  Future<List<DailyPaymentsModel>> dailyPayments(String idempresa) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var host = prefs.getString("host");
      var port = prefs.getString("port");

      var url =
          'http://$host:$port/datasnap/rest/TServerAPPnfe/Pagdiario/$idempresa';
      print("URL > ${url}");

      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      var res = await DailyPaymentsModel.fromJsonList(jsonData);

      return res;
    } catch (e) {
      log(e.toString());
      return [DailyPaymentsModel()];
    }
  }

}
