import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prosystem_dashboard/app/core/ui/custom_buttom.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/cubit/payment_daily_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/cubit/payment_daily_bloc_state.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/widgets/indicator_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentDailyPage extends StatefulWidget {
  const PaymentDailyPage({super.key});

  @override
  State<PaymentDailyPage> createState() => _PaymentDailyPageState();
}

class _PaymentDailyPageState extends State<PaymentDailyPage> {
  int touchedIndex = -1;
  String? _selectedMonth;
  String? _selectMonth;
  final List<String> _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentDailyCubit, PaymentDailyBlocState>(
      listener: (context, state) {
        // TODO: implement listener
        print("${state.paymentDailyModel!.metadodia!}");
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(children: [
            Row(
              spacing: 15,
              children: [
                SizedBox(width: 10,),
                DropdownButton<String>(
                  value: _selectedMonth,
                  hint: Text('Selecione um mês'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMonth = newValue;
                    });
                    int monthNumber = _months.indexOf(newValue!) + 1;
                    String formattedMonthNumber = monthNumber.toString()
                        .padLeft(2, '0');

                    print('Mês selecionado: $newValue, $formattedMonthNumber');
                    _selectMonth = formattedMonthNumber;
                  },
                  items: _months.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Ano',
                      hintText: 'Digite o ano',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (value) {
                      if (value.length == 4) {
                        _selectMonth = _selectMonth! + value;
                        print('Ano digitado: $_selectMonth');
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o ano';
                      }
                      if (value.length != 4) {
                        return 'O ano deve ter 4 dígitos';
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
            CustomButton(
              onPressed: () async {
                await context
                    .read<PaymentDailyCubit>().paymentDaily(idempresa: "1", mesano: _selectMonth!);
              },
              text: "Aplicar",
              disabled: false,
            ),
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
                            touchCallback: (FlTouchEvent event,
                                pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
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
                          sections: showingSections(double.parse(state.paymentDailyModel!.metadodia!.replaceAll(',', '.'))
                              , double.parse(state.paymentDailyModel!.metaparcial!.replaceAll(',', '.'))),
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

          ],),

        );
      },
    );
  }

  List<PieChartSectionData> showingSections(
      double metaDia, double metaParcial) {
    print("Metas > ${metaDia} + ${metaParcial}");
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
            title: metaDia == 0.0 ? "" : metaDia.toString(),
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
            title: metaParcial == 0.0 ? "" : metaParcial.toString(),
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

