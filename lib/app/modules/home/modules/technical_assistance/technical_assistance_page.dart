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
                  Row(
                    children: [
                      Text("Quantidade de Assistências cadastradas ", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("${products.totalAssistencia ?? ""}")
                    ],
                  ),
                  Text("Quantidade de Assistências ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Row(
                    spacing: 10,
                    children: [
                      Column(
                        children: [
                          Text("em aberto", style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${products.totalAssispend ?? 0}")
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          Text("Baixadas", style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("${products.totalAssisbx ?? 0}"),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return products.abcAssistencia != null
                            ? DataTable(
                          columnSpacing: 14.0,
                          dataRowHeight: 60.0,
                          columns: [
                            DataColumn(
                                label: Text('Produtos',
                                    style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(
                              label: Text('Quant',
                                  style: TextStyle(fontWeight: FontWeight.bold)),),
                            DataColumn(
                                label: Text('Porc(%)',
                                    style: TextStyle(fontWeight: FontWeight.bold)),),

                          ],
                          rows: products.abcAssistencia != null
                              ? products.abcAssistencia!.map((product) {
                            return DataRow(cells: [
                              DataCell(
                                SizedBox(
                                  width: constraints.maxWidth * 0.40,
                                  child: Text(
                                    product.produto ?? '---',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: constraints.maxWidth * 0.25,
                                  child: Text(
                                    product.quant?.toString() ?? '0',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: constraints.maxWidth * 0.25,
                                  child: Text(
                                    product.porc?.toString() ?? '0%',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ]);
                          }).toList()
                              : [],
                        ) : Text("");
                      },
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
