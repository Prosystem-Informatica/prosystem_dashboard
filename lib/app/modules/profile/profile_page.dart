import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repositories/login/model/user_auth_model.dart';
import '../login/cubit/login_bloc_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserAuthModel args = Get.arguments;
  String _username = '';
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF0511F2),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              _username.isEmpty ? args.fantasia ?? '' : _username,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(args.empresa ?? ''),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Configurações"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('cnpj');
              await prefs.remove('username');
              await prefs.remove('password');
              await prefs.remove('host');
              await prefs.remove('port');
              await prefs.setBool('saveCredentials', false);
              if (context.mounted) {
                context.read<LoginBlocCubit>().reset();
              }
              Get.offAllNamed("/login");
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              'Versão $_appVersion',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
