import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prosystem_dashboard/app/repositories/month_payments/models/month_payments_model.dart';

class LineChartWidget extends StatefulWidget {
  final MonthPaymentsModel? monthPaymentsModel;
  final bool isShowingMainData;
  final String selectedMonth;

  const LineChartWidget({
    super.key,
    required this.monthPaymentsModel,
    required this.isShowingMainData,
    required this.selectedMonth,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late List<String> monthLabels;

  @override
  void initState() {
    super.initState();
    monthLabels = _getLastFiveMonths(widget.selectedMonth);
  }

  @override
  void didUpdateWidget(covariant LineChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth) {
      monthLabels = _getLastFiveMonths(widget.selectedMonth);
    }
  }

  List<String> _getLastFiveMonths(String selectedMonth) {
    final month = int.parse(selectedMonth.substring(0, 2));
    final year = int.parse(selectedMonth.substring(2));

    List<String> result = [];

    // Começamos do mês -5 até o mês -1 (excluindo o atual)
    for (int i = 5; i >= 1; i--) {
      int calculatedMonth = month - i;
      int calculatedYear = year;

      while (calculatedMonth < 1) {
        calculatedMonth += 12;
        calculatedYear -= 1;
      }

      result.add('${_getMonthAbbreviation(calculatedMonth)}/$calculatedYear');
    }

    return result;
  }


  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Fev';
      case 3: return 'Mar';
      case 4: return 'Abr';
      case 5: return 'Mai';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Ago';
      case 9: return 'Set';
      case 10: return 'Out';
      case 11: return 'Nov';
      case 12: return 'Dez';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 14,
    maxY: 4,
    minY: 0,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    mesAtual,
    mesAnt,
    mesTresAnt,
    mesQuatroAnt,
    lineChartBarData1_5,
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    if (value.toInt() >= 0 && value.toInt() < monthLabels.length) {
      return SideTitleWidget(
        meta: meta,
        space: 0,
        child: Text(monthLabels[value.toInt()], style: style),
      );
    }
    return const SizedBox.shrink();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    Widget text;
    switch (value.toInt()) {
      case 4:
        text = const Text('1.000.000', style: style);
        break;
      case 8:
        text = const Text('2.000.000', style: style);
        break;
      case 12:
        text = const Text('3.000.000', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 28,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 60,
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Colors.blueAccent.withOpacity(0.2), width: 4),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  double getProportionalXValue(double faturamento) {
    const double minFaturamento = 2000000;
    const double maxFaturamento = 3000000;
    const double minX = 8.0;
    const double maxX = 12.0;

    faturamento = faturamento.clamp(minFaturamento, maxFaturamento);
    double proporcao = (faturamento - minFaturamento) / (maxFaturamento - minFaturamento);
    return minX + (maxX - minX) * proporcao;
  }

  LineChartBarData get mesAtual => LineChartBarData(
    isCurved: true,
    color: Colors.green,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(0, 1),
      FlSpot(getProportionalXValue(double.parse(widget.monthPaymentsModel?.total1?.replaceAll(',', '.') ?? "0.0")), 1),
    ],
  );

  LineChartBarData get mesAnt => LineChartBarData(
    isCurved: true,
    color: Colors.pink,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(0, 2),
      FlSpot(getProportionalXValue(double.parse(widget.monthPaymentsModel?.total2?.replaceAll(',', '.') ?? "0.0")), 2),
    ],
  );

  LineChartBarData get mesTresAnt => LineChartBarData(
    isCurved: true,
    color: Colors.cyan,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(0, 3),
      FlSpot(getProportionalXValue(double.parse(widget.monthPaymentsModel?.total3?.replaceAll(',', '.') ?? "0.0")), 3),
    ],
  );

  LineChartBarData get mesQuatroAnt => LineChartBarData(
    isCurved: true,
    color: Colors.redAccent,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(0, 4),
      FlSpot(getProportionalXValue(double.parse(widget.monthPaymentsModel?.total4?.replaceAll(',', '.') ?? "0.0")), 4),
    ],
  );

  LineChartBarData get lineChartBarData1_5 => LineChartBarData(
    isCurved: true,
    color: Colors.black,
    barWidth: 8,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: [
      FlSpot(0, 0),
      FlSpot(getProportionalXValue(double.parse(widget.monthPaymentsModel?.total5?.replaceAll(',', '.') ?? "0.0")), 0),
    ],
  );
}