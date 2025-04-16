import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prosystem_dashboard/app/repositories/financial/model/financial_model.dart';

class LineChartWidgetBills extends StatefulWidget {
  final List<DespesaFixa> despesasFixas;

  const LineChartWidgetBills({
    super.key,
    required this.despesasFixas,
  });

  @override
  State<LineChartWidgetBills> createState() => _LineChartWidgetBillsState();
}

class _LineChartWidgetBillsState extends State<LineChartWidgetBills> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(),
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) {
            return spots.map((spot) {
              final fornecedor = widget.despesasFixas[spot.barIndex].fornecedor;
              final valor = widget.despesasFixas[spot.barIndex].valor;
              return LineTooltipItem(
                '$fornecedor\nR\$ ${_formatCurrency(valor ?? "0.0")}',
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidget,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 100,
            getTitlesWidget: leftTitleWidget,
          ),
        ),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 12, // Mantemos 12 como máximo para os 3 intervalos
      minY: 0,
      maxY: widget.despesasFixas.length.toDouble() - 1,
      lineBarsData: lineBarsData(),
    );
  }

  List<LineChartBarData> lineBarsData() {
    return List.generate(widget.despesasFixas.length, (index) {
      final valor = double.tryParse(
          widget.despesasFixas[index].valor?.replaceAll(',', '.') ?? '0') ??
          0;
      return LineChartBarData(
        spots: [
          FlSpot(0, index.toDouble()),
          FlSpot(_convertValueToX(valor), index.toDouble()),
        ],
        isCurved: true,
        color: Colors.primaries[index % Colors.primaries.length],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      );
    });
  }

  double _convertValueToX(double value) {
    // Conversão direta para os intervalos fixos
    if (value <= 5000) return (value / 5000) * 4;
    if (value <= 15000) return 4 + ((value - 5000) / 10000) * 4;
    return 8 + ((value - 15000) / 15000) * 4;
  }

  Widget bottomTitleWidget(double value, TitleMeta meta) {
    // Mostra apenas nos pontos fixos que queremos
    if (value == 0) return const Text('0', style: TextStyle(fontSize: 12));
    if (value == 4) return const Text('5k', style: TextStyle(fontSize: 12));
    if (value == 8) return const Text('15k', style: TextStyle(fontSize: 12));
    if (value == 12) return const Text('30k', style: TextStyle(fontSize: 12));
    return Container();
  }

  Widget leftTitleWidget(double value, TitleMeta meta) {
    if (value.toInt() < widget.despesasFixas.length) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          widget.despesasFixas[value.toInt()].fornecedor ?? '',
          style: const TextStyle(fontSize: 10),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return const Text('');
  }

  String _formatCurrency(String value) {
    return value.replaceAll('.', ',');
  }
}