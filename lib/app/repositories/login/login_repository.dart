import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:prosystem_dashboard/app/core/rest/rest_client.dart';
import 'package:prosystem_dashboard/app/repositories/login/i_login_repository.dart';
import 'package:prosystem_dashboard/app/repositories/login/model/user_auth_model.dart';
import 'package:prosystem_dashboard/app/repositories/login/model/validation_model.dart';

class LoginRepository implements ILoginRepository {
  final RestClient _rest;

  const LoginRepository({
    required RestClient rest,
  }) : _rest = rest;

  /*@override
  Future<ValidationModel> login(String cnpj) async {
    try {
      final response = await _rest.get("9090/datasnap/rest/TserverAPPnfe/LoginEmpresa/$cnpj", headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 401) {
      }

      var res = await ValidationModel.fromJson(response.data);

      return res;
    } catch(e){
      log(e.toString());
      return ValidationModel();
    }
  }*/

  @override
  Future<ValidationModel> login(String cnpj) async {
    try {
      var url =
          'http://prosystem.dyndns-work.com:9090/datasnap/rest/TserverAPPnfe/LoginEmpresa/$cnpj';
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);
      print("Json > ${jsonData}");

      var res = await ValidationModel.fromJson(jsonData[0]);

      return res;
    } catch (e) {
      log(e.toString());
      return ValidationModel();
    }
  }

  @override
  Future<List<UserAuthModel>> loginUser(String port, String username, String password) async {
    try {
      var url =
          'http://prosystem02.dyndns-work.com:$port/datasnap/rest/TServerAPPnfe/LoginApp/$username/$password';
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);
      print("Json Works> ${jsonData}");

      List<UserAuthModel> users = (jsonData as List)
          .map((item) => UserAuthModel.fromJson(item))
          .toList();

      return users;
    } catch (e) {
      log(e.toString());
      return [UserAuthModel()];
    }
  }
}
