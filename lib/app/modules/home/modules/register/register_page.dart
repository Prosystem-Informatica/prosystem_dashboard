import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/register/cubit/register_bloc_state.dart';

import '../../../../core/ui/custom_buttom.dart';
import '../../../../core/ui/helpers/format_money.dart';
import '../../../../repositories/login/model/user_auth_model.dart';
import 'cubit/register_bloc_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserAuthModel args = UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  late TextEditingController age = TextEditingController();

  int touchedIndex = -1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData(args.empresa!, _selectMonth!);

  }

  double parseStringToDouble(String value) {
    String formattedValue = value.replaceAll(',', '.');
    return double.tryParse(formattedValue) ?? 0.0;
  }

  final List<String> _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  _fetchData(String idempresa, String mesano) async {
    print("Oq foi enviando ${idempresa} + ${mesano}");
    await context
        .read<RegisterCubit>()
        .register(idempresa: idempresa, mesano: mesano);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.fantasia!,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0511F2),
      ),
      body: BlocConsumer<RegisterCubit, RegisterBlocState>(
        listener: (context, state) {
          // TODO: implement listener
          print("Dentro do listerner ${state.registerModel}");
        },
        builder: (context, state) {
          if (state.status == RegisterStatus.success) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      "Clientes incluido no mês",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    state.registerModel?.clienteinc?.isEmpty == null
                        ? Text("0")
                        : Text(state.registerModel!.clienteinc!),
                    Text(
                      "Total de clientes ativos",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    state.registerModel?.clienteinc?.isEmpty == null
                        ? Text("0")
                        : Text(state.registerModel!.clienteatv! ?? ""),
                    Text(
                      "Total de clientes inativo",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    state.registerModel?.clienteinc?.isEmpty == null
                        ? Text("0")
                        : Text(state.registerModel!.clienteinatv!),
                    SizedBox(height: 25,),
                    Text(
                      "Total de clientes rec em atraso no mês",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    state.registerModel?.clienteinc?.isEmpty == null
                        ? Text("0")
                        : Row(
                      spacing: 25,
                          children: [
                            Text(state.registerModel!.clienteatrasoqtd!),
                            Text(formatCurrency(state.registerModel!.clienteatrasovlr ?? "0,0"),),

                          ],
                        ),
                    Text(
                      "Total de título vencidos",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    state.registerModel?.clienteinc?.isEmpty == null
                        ? Text("0")
                        : Row(
                      spacing: 25,
                          children: [
                            Text(state.registerModel!.geralrecatrasoqtd!),
                            Text(formatCurrency(state.registerModel!.geralatrasovlr ?? "0,0"),),
                          ],
                        ),
                  ],
                ),
              ),
            );
          } else if (state.status == RegisterStatus.loading) {
            return Scaffold(
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Carregando informações!!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
          } else {
            return Column(
              children: [
                Text("Clientes incluido no mês"),
                Text("0"),
                Text("Total de clientes ativos"),
                Text("0"),
                Text("Total de clientes inativo"),
                Text("0"),
                Text("Total de clientes rec em atraso no mês"),
                Text("0"),
                Text("Total de título vencidos"),
                Text("0"),
              ],
            );
          }
        },
      ),
    );
  }
}
