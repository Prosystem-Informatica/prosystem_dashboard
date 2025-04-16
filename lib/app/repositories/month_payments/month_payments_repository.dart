import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/repositories/month_payments/models/month_payments_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i_month_payments_repository.dart';

class MonthPaymentsRepository implements IMonthPaymentsRepository {
  final RestClient _rest;
  late SharedPreferences prefs;
  MonthPaymentsRepository({
    required RestClient rest,
  }) : _rest = rest;


  @override
  Future<MonthPaymentsModel> monthPayments(
      String idempresa, String mesano) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var host = prefs.getString("host");
      var port = prefs.getString("port");
      print("Info enviado ${idempresa} e mes ${mesano}");

      var url =
          'http://$host:$port/datasnap/rest/TServerAPPnfe/FatMensal/$mesano/$idempresa';

      print("URL > ${url}");

      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      var res = await MonthPaymentsModel.fromJson(jsonData);

      print("Oq temos no repo do month > ${res.toString()}");

      return res;
    } catch (e) {
      log(e.toString());
      return MonthPaymentsModel();
    }
  }
}
