import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/month_payments/cubit/month_payments_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/month_payments/cubit/month_payments_bloc_state.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/month_payments/widgets/line_chart_widget.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/month_payments/widgets/pie_chart_widget.dart';

import '../../../../core/ui/custom_buttom.dart';
import '../../../../core/ui/helpers/format_date.dart';
import '../../../../core/ui/helpers/format_money.dart';
import '../../../../repositories/login/model/user_auth_model.dart';
import '../widgets/indicator_widget.dart';

class MonthPaymentsPage extends StatefulWidget {
  const MonthPaymentsPage({super.key});

  @override
  State<MonthPaymentsPage> createState() => _MonthPaymentsPageState();
}

class _MonthPaymentsPageState extends State<MonthPaymentsPage> {
  final UserAuthModel args = UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  late TextEditingController age = TextEditingController();
  late bool isShowingMainData;

  int touchedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isShowingMainData = true;

    context
        .read<MonthPaymentsBlocCubit>()
        .paymentDaily(idempresa: args.empresa!, mesano: _selectMonth!);
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

  final List<Color> cores = [
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.lime,
    Colors.brown,
    Colors.grey,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
  ];



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
      body: BlocConsumer<MonthPaymentsBlocCubit, MonthPaymentsBlocState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state.status == MonthPaymentsStatus.success) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Faturamento  de ${formatAndValidateMMYYYY(_selectMonth)}",
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
                                        state.monthPaymentsModel!.meta ?? "0.0"),
                                    parseStringToDouble(state
                                        .monthPaymentsModel!.metaparcial ?? "0.0")),
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
                                text: "Meta do mês ${formatCurrency(state.monthPaymentsModel!.meta ?? "0.0")}",
                                isSquare: true,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Indicator(
                                color: Colors.red.shade900,
                                text: 'Valor faturado ${formatCurrency(state.monthPaymentsModel!.metaparcial ?? "0.0")}',
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
                  AspectRatio(
                    aspectRatio: 1.23,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: 37,
                            ),
                            const Text(
                              'Faturamento Ultimo 5 meses',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 37,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16, left: 6),
                                child:LineChartWidget(
                                  isShowingMainData: isShowingMainData,
                                  monthPaymentsModel: state.monthPaymentsModel,
                                  selectedMonth: _selectMonth,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PieChartWidget(monthPaymentsModel: state.monthPaymentsModel,cores: cores,),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(height: 18),
                        Column(
                          spacing: 10,
                          children: state.monthPaymentsModel?.representantes?.map<Widget>((representante) {
                            if (representante == null) {
                              return const SizedBox.shrink();
                            }
                            final int index = state.monthPaymentsModel?.representantes?.indexOf(representante) ?? -1;
                            final Color color = index != -1
                                ? cores[index % cores.length]
                                : Colors.grey;

                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 2),
                              child: Indicator(
                                color: color,
                                text: "${representante.nome ?? 'N/A'} - ${formatCurrency(representante.total ?? "0.0") ?? '0'}",
                                isSquare: true,
                              ),
                            );
                          }).toList() ?? [
                            const Text("Nenhum representante encontrado", style: TextStyle(color: Colors.red)),
                          ],
                        )
                      ],
                    ),
                  ),

                ],
              ),
            );
          } else if (state.status == MonthPaymentsStatus.loading) {
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
                SizedBox(
                  height: 25,
                ),

                SizedBox(height: 20),
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
            radius: radius,
            title: "",
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
