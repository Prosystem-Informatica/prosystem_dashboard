import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/repositories/register/models/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i_register_repository.dart';

class RegisterRepository implements IRegisterRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

   RegisterRepository({
    required RestClient rest,
  }) : _rest = rest;


  @override
  Future<RegisterModel> register(String idempresa, String mesano) async {
    try {
      prefs = await SharedPreferences.getInstance();
      var host = prefs.getString("host");
      var port = prefs.getString("port");

      var url =
          'http://$host:$port/datasnap/rest/TServerAPPnfe/Cadastro/$mesano/$idempresa';
      print("URL > ${url}");

      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      var res = RegisterModel.fromJson(jsonData);

      return res;
    } catch (e) {
      log(e.toString());
      return RegisterModel();
    }
  }

}
