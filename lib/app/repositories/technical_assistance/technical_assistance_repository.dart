import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/repositories/technical_assistance/i_technical_assistance_repository.dart';
import 'package:prosystem_dashboard/app/repositories/technical_assistance/models/technical_assistance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TechnicalAssistanceRepository implements ITechnicalAssistanceRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

  TechnicalAssistanceRepository({
    required RestClient rest,
  }) : _rest = rest;


  @override
  Future<TechnichalAssistenceModel> technicalAssistance(String mesano, String idempresa) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var host = prefs.getString("host");
      var port = prefs.getString("port");

      var url =
          'http://$host:$port/datasnap/rest/TServerAPPnfe/AssistenciaTec/$mesano/$idempresa';
      print("URL > ${url}");

      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      var res = await TechnichalAssistenceModel.fromJson(jsonData);

      return res;
    } catch (e) {
      log(e.toString());
      return TechnichalAssistenceModel();
    }
  }

}
