import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prosystem_dashboard/app/core/ui/custom_buttom.dart';
import 'package:prosystem_dashboard/app/core/ui/helpers/format_money.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/cubit/payment_daily_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/cubit/payment_daily_bloc_state.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/widgets/indicator_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/helpers/format_date.dart';
import '../../../../repositories/login/model/user_auth_model.dart';

class PaymentDailyPage extends StatefulWidget {
  const PaymentDailyPage({super.key});

  @override
  State<PaymentDailyPage> createState() => _PaymentDailyPageState();
}

class _PaymentDailyPageState extends State<PaymentDailyPage> {
  final UserAuthModel args = UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  late TextEditingController age = TextEditingController();

  int touchedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<PaymentDailyCubit>()
        .paymentDaily(idempresa: args.empresa!, mesano: _selectMonth);
  }

  double parseStringToDouble(String value) {
    String formattedValue = value.replaceAll(',', '.');
    return double.tryParse(formattedValue) ?? 0.0;
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
      body: BlocConsumer<PaymentDailyCubit, PaymentDailyBlocState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state.status == PaymentDailyStatus.success) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Faturamento ${formatAndValidateMMYYYY(_selectMonth)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 40,
                                sections: showingSections(
                                    parseStringToDouble(
                                        state.paymentDailyModel!.metadodia!),
                                    parseStringToDouble(
                                        state.paymentDailyModel!.metaparcial!)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 2,
                            children: <Widget>[
                              Indicator(
                                color: Colors.blue.shade900,
                                text: "Meta do dia ${formatCurrency(state.paymentDailyModel!.metadodia ?? "0.0")}",
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Indicator(
                                color: Colors.red.shade900,
                                text: 'Valor faturado ${formatCurrency(state.paymentDailyModel!.metaparcial ?? "0.0")}',
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          "Quant. de Pedidos do dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.paymentDailyModel!.qtdpedidos!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Quant. de Cheques no dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.paymentDailyModel!.qtdcheques!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Quant. de Cheques Baixada/Passado no dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.paymentDailyModel!.qtdchequesbx!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Quant. de Cheques abertos no dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.paymentDailyModel!.qtdchequesab!,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (state.status == PaymentDailyStatus.loading) {
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
          }
          return SingleChildScrollView(
            child: Wrap(
              children: [
                SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 18,
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: showingSections(
                                  double.parse("00" ??
                                      state.paymentDailyModel!.metadodia!
                                          .replaceAll(',', '.')),
                                  double.parse("00" ??
                                      state.paymentDailyModel!.metaparcial!
                                          .replaceAll(',', '.'))),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 2,
                          children: <Widget>[
                            Indicator(
                              color: Colors.blue.shade900,
                              text: "Meta do dia",
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Indicator(
                              color: Colors.red.shade900,
                              text: 'Valor parcial',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 25,
                  height: 35,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Quant. de Pedidos do dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Quant. de Cheques no dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Quant. de Cheques Baixada/Passado no dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Quant. de Cheques abertos no dia",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      double metaDia, double metaParcial) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue.shade900,
            value: metaDia == 0.0 ? 1 : metaDia,
            title: "",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red.shade900,
            value: metaParcial == 0.0 ? 1 : metaParcial,
            title: "",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
