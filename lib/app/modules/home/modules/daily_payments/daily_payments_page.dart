import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/core/ui/helpers/format_money.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/daily_payments/cubit/daily_payments_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/daily_payments/cubit/daily_payments_bloc_state.dart';
import 'package:prosystem_dashboard/app/repositories/daily_payments/models/daily_payments_model.dart';

import '../../../../core/ui/helpers/format_date.dart';
import '../../../../repositories/login/model/user_auth_model.dart';

class DailyPaymentsPage extends StatefulWidget {
  const DailyPaymentsPage({super.key});

  @override
  State<DailyPaymentsPage> createState() => _DailyPaymentsPageState();
}

class _DailyPaymentsPageState extends State<DailyPaymentsPage> {
  final UserAuthModel args = UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  List<DailyPaymentsModel> products = [
    DailyPaymentsModel(
        fornecedor: "GLASSCONTROL/TEST",
        pagontem: "0,00",
        paghoje: "115,50",
        pagamanha: "3190,00"),
    DailyPaymentsModel(
        fornecedor: "GLASSCONTROL/TEST",
        pagontem: "0,00",
        paghoje: "115,50",
        pagamanha: "3190,00"),
    DailyPaymentsModel(
        fornecedor: "GLASSCONTROL/TEST",
        pagontem: "0,00",
        paghoje: "115,50",
        pagamanha: "3190,00"),
    DailyPaymentsModel(
        fornecedor: "GLASSCONTROL/TEST",
        pagontem: "0,00",
        paghoje: "115,50",
        pagamanha: "3190,00"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DailyPaymentsCubit>().dailyPayments(idempresa: args.empresa!);
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
      body: BlocConsumer<DailyPaymentsCubit, DailyPaymentsBlocState>(
        listener: (context, state) {
          // TODO: implement listener
          products = state.dailyPaymentsModel!;
        },
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return DataTable(
                    columnSpacing: 14.0,
                    dataRowHeight: 60.0,
                    columns: [
                      DataColumn(
                          label: Text('Fornecedor',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Column(
                            children: [
                              Text('total',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(formatDate(DateTime.now().subtract(Duration(days: 1))),style: TextStyle(fontSize: 12),)
                            ],
                          ),),
                      DataColumn(
                          label: Column(
                            children: [
                              Text('total',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(formatDate(DateTime.now()),style: TextStyle(fontSize: 12),)

                            ],
                          )),
                      DataColumn(
                          label: Column(
                            children: [
                              Text('total',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(formatDate(DateTime.now().add(Duration(days: 1))),style: TextStyle(fontSize: 12),)

                            ],
                          )),
                    ],
                    rows: products.map((product) {
                      return DataRow(cells: [
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.16,
                            child: Text(
                              product.fornecedor!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.22,
                            child: Text(
                              formatCurrency(product.pagontem ?? "0,0"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.21,
                            child: Text(
                              formatCurrency(product.paghoje ?? "0,0"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: constraints.maxWidth * 0.3,
                            child: Text(
                              formatCurrency(product.pagamanha ?? "0,0"),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
