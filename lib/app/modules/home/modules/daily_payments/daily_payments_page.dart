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
  final UserAuthModel args =
  UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  List<DailyPaymentsModel> products = [];

  @override
  void initState() {
    super.initState();
    context.read<DailyPaymentsCubit>().dailyPayments(idempresa: args.empresa!);
  }

  Widget styledValue(String value) {
    final double val = double.tryParse(
      value.replaceAll('.', '').replaceAll(',', '.'),
    ) ??
        0.0;

    return Text(
      formatCurrency(value),
      style: TextStyle(
        color: val > 0 ? Colors.green.shade700 : Colors.black54,
        fontWeight: val > 0 ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  TextStyle _valueStyle(String? value) {
    final double val = double.tryParse(
      value?.replaceAll('.', '').replaceAll(',', '.') ?? '0.0',
    ) ??
        0.0;

    return TextStyle(
      color: val > 0 ? Colors.green.shade800 : Colors.black54,
      fontWeight: val > 0 ? FontWeight.bold : FontWeight.normal,
      fontSize: 15,
    );
  }


  @override
  Widget build(BuildContext context) {
    final ontem = formatDate(DateTime.now().subtract(const Duration(days: 1)));
    final hoje = formatDate(DateTime.now());
    final amanha = formatDate(DateTime.now().add(const Duration(days: 1)));

    return Scaffold(
      appBar: AppBar(
        title: Text(args.fantasia!, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0511F2),
      ),
      body: BlocConsumer<DailyPaymentsCubit, DailyPaymentsBlocState>(
        listener: (context, state) {
          if (state.dailyPaymentsModel != null) {
            products = state.dailyPaymentsModel!;
          }
        },
        builder: (context, state) {
          double totalOntem = products.fold(
            0.0,
                (acc, e) =>
            acc +
                double.tryParse(
                  e.pagontem!.replaceAll('.', '').replaceAll(',', '.'),
                )!.toDouble(),
          );
          double totalHoje = products.fold(
            0.0,
                (acc, e) =>
            acc +
                double.tryParse(
                  e.paghoje!.replaceAll('.', '').replaceAll(',', '.'),
                )!.toDouble(),
          );
          double totalAmanha = products.fold(
            0.0,
                (acc, e) =>
            acc +
                double.tryParse(
                  e.pagamanha!.replaceAll('.', '').replaceAll(',', '.'),
                )!.toDouble(),
          );

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length + 1,
            itemBuilder: (context, index) {
              if (index == products.length) {
                return Card(
                  color: Colors.green[100],
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Geral',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("Total $ontem: ${formatCurrency(totalOntem.toString())}"),
                        Text("Total $hoje: ${formatCurrency(totalHoje.toString())}"),
                        Text("Total $amanha: ${formatCurrency(totalAmanha.toString())}"),
                      ],
                    ),
                  ),
                );
              }

              final product = products[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade100, width: 1.5),
                ),
                color: Colors.blue.shade50,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.store, color: Colors.indigo),
                          SizedBox(width: 8),
                          Text(
                            'Fornecedor:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Text(
                        product.fornecedor ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Total $ontem: ${formatCurrency(product.pagontem ?? '0,0')}',
                              style: _valueStyle(product.pagontem),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Total $hoje: ${formatCurrency(product.paghoje ?? '0,0')}',
                              style: _valueStyle(product.paghoje),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Total $amanha: ${formatCurrency(product.pagamanha ?? '0,0')}',
                              style: _valueStyle(product.pagamanha),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
