import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prosystem_dashboard/app/core/ui/helpers/messages.dart';
import 'package:prosystem_dashboard/app/modules/login/cubit/login_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/login/cubit/login_bloc_state.dart';
import '../../core/ui/custom_buttom.dart';
import '../../core/ui/helpers/upper_case_text_formatter.dart';
import '../../core/ui/text_field_custom.dart';
import '../../repositories/login/model/user_auth_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Messages<LoginPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  late TextEditingController cnpj = TextEditingController();
  late TextEditingController username = TextEditingController();
  late TextEditingController password = TextEditingController();
  bool saveCredentials = false;
  String _persistedHost = '';

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cnpj.text = prefs.getString('cnpj') ?? '';
      username.text = prefs.getString('username') ?? '';
      password.text = prefs.getString('password') ?? '';
      saveCredentials = prefs.getBool('saveCredentials') ?? false;
      _persistedHost = prefs.getString('host') ?? '';
    });
  }

  Future<void> _authenticate() async {
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !isDeviceSupported) {
      print('Biometria não suportada ou não disponível.');
      return;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Autentique-se para acessar o aplicativo',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        final savedCnpj = prefs.getString('cnpj');
        if (savedCnpj != null) {
          await context.read<LoginBlocCubit>().login(savedCnpj);
          await context.read<LoginBlocCubit>().loginUser(
                prefs.getString('username') ?? username.text.toUpperCase(),
                prefs.getString('password') ?? password.text.toUpperCase(),
              );
        }
      } else {
        showError("Autenticação falhou ou foi cancelada.");
      }
    } catch (e) {
      showError("Erro durante a autenticação");
      print('Erro durante a autenticação: $e');
    }
  }

  void _showDialog(BuildContext context, List<UserAuthModel> userAuth) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Selecione a empresa',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
              color: Color(0xFF0511F2),
            ),
          ),
          children: userAuth
              .where((user) => user.fantasia != null && user.codigo != null)
              .map((user) {
            return ListTile(
              leading: const Icon(Icons.business_sharp),
              title: Text(user.fantasia!),
              onTap: () {
                Navigator.pop(context);
                Get.offAllNamed("/home", arguments: user);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBlocCubit, LoginBlocState>(
      listener: (context, state) {
        log("Objeto > ${state.validationModel}");
        state.status.matchAny(
          success: () async {
            final prefs = await SharedPreferences.getInstance();
            final servidor = state.validationModel?.servidor;
            final porta = state.validationModel?.porta;

            if (servidor != null && porta != null) {
              await prefs.setString('host', servidor.toLowerCase());
              await prefs.setString('port', porta);
              if (mounted) setState(() => _persistedHost = servidor.toLowerCase());
            }

            showSuccess(state.successMessage ?? "Sucesso");

            if (state.successMessage == "Login Realizado com Sucesso!!") {
              if (saveCredentials) {
                await prefs.setString('cnpj', cnpj.text);
                await prefs.setString('username', username.text);
                await prefs.setString('password', password.text);
                await prefs.setBool('saveCredentials', true);
              }
              if (mounted) _showDialog(context, state.userAuthModel!);
            }
          },
          error: () {
            showError(state.errorMessage ?? "Erro não informado");
          },
          any: () {},
        );
      },
      builder: (context, state) {
        final codigo = state.validationModel?.codigo ?? '';
        final cnpjValidated =
            (codigo.isNotEmpty && codigo != "0") || _persistedHost.isNotEmpty;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg-login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/logo-pro.png"),
                  TextFieldCustom(
                    controller: cnpj,
                    label: 'CNPJ',
                    hintText: 'Cnpj',
                    inputType: TextInputType.number,
                  ),
                  Visibility(
                    visible: cnpjValidated,
                    child: TextFieldCustom(
                      controller: username,
                      label: 'Usuario',
                      hintText: 'Usuario',
                      formatters: [UpperCaseTextFormatter()],
                    ),
                  ),
                  Visibility(
                    visible: cnpjValidated,
                    child: TextFieldCustom(
                      controller: password,
                      label: 'Senha',
                      hintText: 'Senha',
                      obscureText: true,
                      formatters: [UpperCaseTextFormatter()],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: saveCredentials,
                        onChanged: (value) {
                          setState(() => saveCredentials = value ?? false);
                        },
                      ),
                      const Text("Salvar credenciais"),
                    ],
                  ),
                  CustomButton(
                    disabled: state.status == LoginStateStatus.loading,
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final codigo = state.validationModel?.codigo ?? '';
                      final host = prefs.getString('host') ?? '';
                      final cnpjOk =
                          (codigo.isNotEmpty && codigo != "0") || host.isNotEmpty;

                      if (!cnpjOk) {
                        if (cnpj.text.trim().isEmpty) {
                          showError("Informe o CNPJ");
                          return;
                        }
                        await context
                            .read<LoginBlocCubit>()
                            .login(cnpj.text.toUpperCase());
                      } else {
                        await context.read<LoginBlocCubit>().loginUser(
                              username.text.toUpperCase(),
                              password.text.toUpperCase(),
                            );
                      }
                    },
                    text: "Entrar",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
