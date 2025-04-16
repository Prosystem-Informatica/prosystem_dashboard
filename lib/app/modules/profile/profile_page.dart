import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/login/model/user_auth_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserAuthModel args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Configurações"),
            onTap: () {

            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sair"),
            onTap: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();

              await prefs.remove('cnpj');
              await prefs.remove('username');
              await prefs.remove('password');
              await prefs.setBool('saveCredentials', false);
              Get.offAllNamed("/login");

            },
          ),
        ],
      ),
    );
  }
}
