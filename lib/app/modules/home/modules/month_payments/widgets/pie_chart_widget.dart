import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prosystem_dashboard/app/repositories/month_payments/models/month_payments_model.dart';

class PieChartWidget extends StatefulWidget {
  final List<Color> cores;
  final MonthPaymentsModel? monthPaymentsModel;

  const PieChartWidget({super.key, required this.monthPaymentsModel, required this.cores});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(widget.monthPaymentsModel, touchedIndex, widget.cores),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(MonthPaymentsModel? month, int touchedIndex, List<Color> cores) {
    if (month == null || month.representantes == null || month.representantes!.isEmpty) {
      return [];
    }

    double totalGeral = month.representantes!.fold(0, (sum, rep) {
      String totalStr = rep.total!.replaceAll(',', '.');
      return sum + double.parse(totalStr);
    });

    final Map<double, Color> valorParaCor = {};

    return List.generate(month.representantes!.length, (i) {
      final representante = month.representantes![i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      String totalStr = representante.total!.replaceAll(',', '.');
      double valor = double.parse(totalStr);

      double porcentagem = (valor / totalGeral) * 100;

      if (!valorParaCor.containsKey(valor)) {
        valorParaCor[valor] = cores[valorParaCor.length % cores.length];
      }

      return PieChartSectionData(
        color: valorParaCor[valor]!,
        value: porcentagem,
        title: '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          'assets/icons/ophthalmology-svgrepo-com.svg',
          size: widgetSize,
          borderColor: Colors.black,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.svgAsset, {
        required this.size,
        required this.borderColor,
      });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .15),
    );
  }
}