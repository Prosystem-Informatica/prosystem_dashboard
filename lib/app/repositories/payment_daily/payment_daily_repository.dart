import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/i_payment_daily_repository.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDailyRepository implements IPaymentDailyRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

  PaymentDailyRepository({
    required RestClient rest,
  }) : _rest = rest;


  @override
  Future<PaymentDailyModel> paymentDaily(
      String idempresa, String mesano) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var host = prefs.getString("host");
      var port = prefs.getString("port");
      print("Info enviado ${idempresa} e mes ${mesano}");
      var url =
          'http://$host:$port/datasnap/rest/TServerAPPnfe/FatDiario/$mesano/$idempresa';
      print("URL > ${url}");

      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      var res = await PaymentDailyModel.fromJson(jsonData[0]);

      print("Pagamento diario ${res.toString()}");

      return res;
    } catch (e) {
      log(e.toString());
      return PaymentDailyModel();
    }
  }
}
