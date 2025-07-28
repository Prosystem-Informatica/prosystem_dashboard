import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
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
  String selectedDay = 'hoje';

  @override
  void initState() {
    super.initState();
    context.read<DailyPaymentsCubit>().dailyPayments(idempresa: args.empresa!);
  }

  TextStyle _valueStyle(String? value) {
    if (value == null || value == '0,00') {
      return const TextStyle(color: Colors.black54, fontSize: 15);
    }

    return TextStyle(
      color: Colors.green.shade800,
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
  }

  double parseBrazilianCurrency(String? value) {
    if (value == null) return 0.0;
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '.')) ?? 0.0;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('ontem', 'Ontem'),
                _buildFilterButton('hoje', 'Hoje'),
                _buildFilterButton('amanha', 'Amanhã'),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<DailyPaymentsCubit, DailyPaymentsBlocState>(
              listener: (context, state) {
                if (state.dailyPaymentsModel != null) {
                  products = state.dailyPaymentsModel!;
                }
              },
              builder: (context, state) {
                final List<DailyPaymentsModel> filteredProducts =
                products.where((product) {
                  final rawValue = selectedDay == 'ontem'
                      ? product.pagontem
                      : selectedDay == 'hoje'
                      ? product.paghoje
                      : product.pagamanha;
                  return rawValue != null && rawValue != '0,00';
                }).toList();

                double totalOntem = products.fold(
                  0.0,
                      (acc, e) => acc + parseBrazilianCurrency(e.pagontem),
                );
                double totalHoje = products.fold(
                  0.0,
                      (acc, e) => acc + parseBrazilianCurrency(e.paghoje),
                );
                double totalAmanha = products.fold(
                  0.0,
                      (acc, e) => acc + parseBrazilianCurrency(e.pagamanha),
                );

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == filteredProducts.length) {
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
                              if (selectedDay == 'ontem')
                                Text("Total $ontem: ${UtilBrasilFields.obterReal(totalOntem)}"),
                              if (selectedDay == 'hoje')
                                Text("Total $hoje:${UtilBrasilFields.obterReal(totalHoje)}"),
                              if (selectedDay == 'amanha')
                                Text("Total $amanha: ${UtilBrasilFields.obterReal(totalAmanha)}"),
                            ],
                          ),
                        ),
                      );
                    }

                    final product = filteredProducts[index];
                    String? value;
                    String label = '';

                    if (selectedDay == 'ontem') {
                      value = product.pagontem;
                      label = 'Total $ontem';
                    } else if (selectedDay == 'hoje') {
                      value = product.paghoje;
                      label = 'Total $hoje';
                    } else {
                      value = product.pagamanha;
                      label = 'Total $amanha';
                    }

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
                                    '$label: ${UtilBrasilFields.obterReal(double.parse(value!.replaceAll('.', '').replaceAll(',', '.') ?? "00.00") ?? 0.0)}',
                                    style: _valueStyle(value),
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String key, String label) {
    final isSelected = selectedDay == key;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isSelected ? const Color(0xFF0511F2) : Colors.grey.shade300,
            foregroundColor: isSelected ? Colors.white : Colors.black,
          ),
          onPressed: () {
            setState(() {
              selectedDay = key;
            });
          },
          child: Text(label),
        ),
      ),
    );
  }
}
