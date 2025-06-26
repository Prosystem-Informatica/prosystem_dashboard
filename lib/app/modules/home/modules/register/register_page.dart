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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String quantity,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Quantidade: $quantity",
                      style: TextStyle(fontSize: 14)),
                  Text("Valor: $value",
                      style: TextStyle(fontSize: 14, color: Colors.green[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            final model = state.registerModel!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.person_add,
                    title: 'Clientes incluídos no mês',
                    quantity: model.clienteinc ?? "0",
                    value: '',
                  ),
                  SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.verified_user,
                    title: 'Clientes ativos',
                    quantity: model.clienteatv ?? "0",
                    value: '',
                  ),
                  SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.person_off,
                    title: 'Clientes inativos',
                    quantity: model.clienteinatv ?? "0",
                    value: '',
                  ),
                  SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.schedule,
                    title: 'Rec. em atraso no mês',
                    quantity: model.clienteatrasoqtd ?? "0",
                    value: formatCurrency(model.clienteatrasovlr ?? "0,0"),
                  ),
                  SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.warning_amber,
                    title: 'Títulos vencidos',
                    quantity: model.geralrecatrasoqtd ?? "0",
                    value: formatCurrency(model.geralatrasovlr ?? "0,0"),
                  ),
                ],
              ),
            );
          } else if (state.status == RegisterStatus.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Carregando informações!!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Clientes incluídos no mês: 0"),
                  Text("Clientes ativos: 0"),
                  Text("Clientes inativos: 0"),
                  Text("Rec. em atraso no mês: 0"),
                  Text("Títulos vencidos: 0"),
                ],
              ),
            );
          }
        },

      ),
    );
  }
}
