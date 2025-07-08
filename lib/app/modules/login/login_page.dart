import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:prosystem_dashboard/app/repositories/login/model/validation_model.dart';
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
  bool isVisible = false;
  bool saveCredentials = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      cnpj.text = prefs.getString('cnpj') ?? '';
      username.text = prefs.getString('username') ?? '';
      password.text = prefs.getString('password') ?? '';
      saveCredentials = prefs.getBool('saveCredentials') ?? false;
    });
  }

  Future<void> _saveCredentials(ValidationModel validationModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("cnpj") == null) {
      if (saveCredentials) {
        await prefs.setString('cnpj', cnpj.text);
        await prefs.setString('host', validationModel.servidor!.toLowerCase());
        await prefs.setString('port', validationModel.porta!);
        await prefs.setString('username', username.text);
        await prefs.setString('password', password.text);
        await prefs.setBool('saveCredentials', true);
      }
    } else {
      await prefs.remove('cnpj');
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.remove('port');
      await prefs.remove('host');
      await prefs.setBool('saveCredentials', false);
    }
  }

  Future<void> _authenticate(ValidationModel? validationModel) async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    bool isDeviceSupported = await _localAuth.isDeviceSupported();
    // TODO : Somente para Testes
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!canCheckBiometrics || !isDeviceSupported) {
      print('Biometria não suportada ou não disponível.');
      return;
    }

    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Autentique-se para acessar o aplicativo',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        print('Autenticação bem-sucedida!');
        if (saveCredentials) {
          if (prefs.getString("cnpj") != null) {
            await context
                .read<LoginBlocCubit>()
                .login(prefs.getString("cnpj") ?? cnpj.text.toUpperCase());

            await context.read<LoginBlocCubit>().loginUser(
                prefs.getString("username") ?? username.text.toUpperCase(),
                prefs.getString("password") ?? password.text.toUpperCase());
          }
        }
      } else {
        showError("Autenticação falhou ou foi cancelada.");
        print('Autenticação falhou ou foi cancelada.');
      }
    } catch (e) {
      showError("Erro durante a autenticação");
      print('Erro durante a autenticação: $e');
    }
  }

  _showDialog(BuildContext context, List<UserAuthModel> userAuth) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Selecione a empresa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
                color: Color(0xFF0511F2),
              ),
            ),
            children: userAuth.map((user) {
              return ListTile(
                leading: Icon(Icons.business_sharp),
                title: Text(user.fantasia!),
                onTap: () {
                  Get.arguments;
                  Navigator.pop(context);
                  Get.offAllNamed("/home", arguments: user);
                },
              );
            }).toList(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBlocCubit, LoginBlocState>(
      listener: (context, state) {
        log("Objeto > ${state.validationModel}");
        state.status.matchAny(
          success: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('host', state.validationModel!.servidor!.toLowerCase());
            await prefs.setString('port', state.validationModel!.porta!);
            showSuccess(state.successMessage ?? "Sucesso");
            if (state.successMessage == "Login Realizado com Sucesso!!") {
              _showDialog(context, state.userAuthModel!);
            }
          },
          error: () {
            showError(state.errorMessage ?? "Erro não informado");
          },
          any: () {},
        );
        if (state.validationModel!.codigo! != "0") {
          isVisible = true;
        } else {
          isVisible = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
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
                    visible: isVisible,
                    child: TextFieldCustom(
                      controller: username,
                      label: 'Usuario',
                      hintText: 'Usuario',
                      formatters: [
                        UpperCaseTextFormatter(),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: TextFieldCustom(
                      controller: password,
                      label: 'Senha',
                      hintText: 'Senha',
                      obscureText: true,
                      formatters: [
                        UpperCaseTextFormatter(),
                      ],
                    ),
                  ),
                  // Checkbox para salvar credenciais
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: saveCredentials,
                        onChanged: (value) {
                          setState(() {
                            saveCredentials = value ?? false;
                          });
                        },
                      ),
                      Text("Salvar credenciais"),
                    ],
                  ),
                  CustomButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      if (saveCredentials == true && prefs.getString("cnpj") != null) {
                        await _saveCredentials(state.validationModel!);
                        _authenticate(state.validationModel!);
                      } else if(saveCredentials == true && prefs.getString("cnpj") == null) {
                        if (state.validationModel!.codigo! == "0" ||
                            state.validationModel!.codigo! == "") {
                          await context.read<LoginBlocCubit>().login(
                              cnpj.text.toUpperCase());
                        } else if (state.validationModel!.porta! != "" ||
                            state.validationModel!.empresa! != "") {
                          await context.read<LoginBlocCubit>().loginUser(
                              username.text.toUpperCase(),
                              password.text.toUpperCase());
                          await _saveCredentials(state.validationModel!);
                        }
                      }else{
                        if (state.validationModel!.codigo! == "0" ||
                            state.validationModel!.codigo! == "") {
                          await context.read<LoginBlocCubit>().login(
                            /*"19685970000104" ??*/ cnpj.text.toUpperCase());
                        } else if (state.validationModel!.porta! != "" ||
                            state.validationModel!.empresa! != "") {
                          await context.read<LoginBlocCubit>().loginUser(
                      /*"SUPORTE" ?? */username.text.toUpperCase(),
                              /*"PR05YST3M" ??  */password.text.toUpperCase());
                        }
                      }
                    },
                    text: "Entrar",
                    disabled: false,
                  ),
                  /*CustomButton(
                    onPressed: () {
                      _authenticate(state.validationModel!);
                    },
                    text: "Entrar com Face ID (TESTES)",
                    disabled: false,
                  ),*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _fetchLogin() async {}
}
