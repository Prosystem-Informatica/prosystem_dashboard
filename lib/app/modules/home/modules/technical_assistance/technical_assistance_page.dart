import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/technical_assistance/cubit/technical_assistance_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/technical_assistance/cubit/technical_assistance_bloc_state.dart';
import 'package:prosystem_dashboard/app/repositories/technical_assistance/models/technical_assistance_model.dart';

import '../../../../core/ui/helpers/format_date.dart';
import '../../../../repositories/daily_payments/models/daily_payments_model.dart';
import '../../../../repositories/login/model/user_auth_model.dart';

class TechnicalAssistancePage extends StatefulWidget {
  const TechnicalAssistancePage({super.key});

  @override
  State<TechnicalAssistancePage> createState() => _TechnicalAssistancePageState();
}

class _TechnicalAssistancePageState extends State<TechnicalAssistancePage> {
  final UserAuthModel args = UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  TechnichalAssistenceModel products = TechnichalAssistenceModel(
    totalAssistencia: "1000,00",
    totalAssispend: "500,00",
    totalAssisbx: "200,00",
    abcAssistencia: [
      AbcAssistencia(produto: "Produto A", quant: "50", porc: "10%"),
      AbcAssistencia(produto: "Produto B", quant: "30", porc: "6%"),
      AbcAssistencia(produto: "Produto C", quant: "20", porc: "4%"),
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  _fetchData() async{
    context.read<TechnicalAssistanceBlocCubit>().technicalAssistance(mesano: _selectMonth, idempresa: args.empresa!);

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
      body: BlocConsumer<TechnicalAssistanceBlocCubit, TechnicalAssistanceBlocState>(
        listener: (context, state) {
          // TODO: implement listener
         products = state.technichalAssistenceModel!;
         print("Produtos no state ${state.technichalAssistenceModel.toString()}");
        },
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quantidade de Assistências cadastradas",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${products.totalAssistencia ?? '0'}",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                        SizedBox(height: 16),

                        Text(
                          "Quantidade de Assistências",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text("Em aberto", style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text("${products.totalAssispend ?? '0'}", style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text("Baixadas", style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text("${products.totalAssisbx ?? '0'}", style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Produtos em destaque",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        ...products.abcAssistencia!.map((product) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(product.produto ?? '---',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text(
                                            "Quantidade: ${product.quant ?? '0'}"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text("Porc.: ${product.porc ?? '0%'}",
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
