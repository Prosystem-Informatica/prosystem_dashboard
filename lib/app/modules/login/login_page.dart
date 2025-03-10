import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/core/ui/helpers/messages.dart';
import 'package:prosystem_dashboard/app/modules/login/cubit/login_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/login/cubit/login_bloc_state.dart';

import '../../core/ui/custom_buttom.dart';
import '../../core/ui/helpers/modal_helper.dart';
import '../../core/ui/text_field_custom.dart';
import '../../repositories/login/model/user_auth_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Messages<LoginPage> {
  late TextEditingController cnpj = TextEditingController();
  late TextEditingController username = TextEditingController();
  late TextEditingController password = TextEditingController();
  bool isVisible = false;

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
          success: () {
            showSuccess(state.successMessage ?? "Sucesso");
            if (state.successMessage == "Login Realizado com Sucesso!!") {
              _showDialog(context, state.userAuthModel!);
              //Get.offAllNamed("/home");
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
                  ),
                  Visibility(
                    visible: isVisible,
                    child: TextFieldCustom(
                      controller: username,
                      label: 'Usuario',
                      hintText: 'Usuario',
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: TextFieldCustom(
                      controller: password,
                      label: 'Senha',
                      hintText: 'Senha',
                      obscureText: true,
                    ),
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (state.validationModel!.codigo! == "0" ||
                          state.validationModel!.codigo! == "") {
                        await context
                            .read<LoginBlocCubit>()
                            .login(cnpj.text); // "19685970000104" ??
                      } else if (state.validationModel!.porta! != "" ||
                          state.validationModel!.empresa! != "") {
                        await context.read<LoginBlocCubit>().loginUser(
                            state.validationModel!.porta!,
                             username.text,
                             password.text); // "SUPORTE" ?? "PR05YST3M" ??
                      }
                    },
                    text: "Entrar",
                    disabled: false,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
