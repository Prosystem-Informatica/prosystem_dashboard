import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/i_payment_daily_repository.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';

class PaymentDailyRepository implements IPaymentDailyRepository {
  final RestClient _rest;

  const PaymentDailyRepository({
    required RestClient rest,
  }) : _rest = rest;

  @override
  Future<PaymentDailyModel> paymentDaily(String idempresa, String mesano) async {
    try {
      var url =
          'http://prosystem02.dyndns-work.com:8082/datasnap/rest/TServerAPPnfe/FatDiario/$mesano/$idempresa';
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);
      print("Json > ${jsonData[0]}");

      var res = await PaymentDailyModel.fromJson(jsonData[0]);

      return res;
    } catch (e) {
      log(e.toString());
      return PaymentDailyModel();
    }
  }

}
