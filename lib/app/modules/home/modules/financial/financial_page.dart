import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/core/ui/helpers/format_money.dart';
import 'package:prosystem_dashboard/app/core/ui/helpers/messages.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/financial/cubit/financial_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/financial/cubit/financial_bloc_state.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/financial/widget/LineCharWidgetBills.dart';

import '../../../../repositories/financial/model/financial_model.dart';
import '../../../../repositories/login/model/user_auth_model.dart';
import '../widgets/indicator_widget.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage>
    with Messages<FinancialPage> {
  final UserAuthModel args =
      UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  List<ContaContabil> _allItemsABC = [];
  List<ContaContabil> _visibleItemsABC = [];
  int _currentABCPage = 1;
  int _itemsABCPerPage = 10;
  bool _isLoading = true;
  String _errorMessage = '';
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _generateTestData();
  }

  void _generateTestData() {
    context
        .read<FinancialBlocCubit>()
        .financial(idempresa: args.empresa!, mesano: _selectMonth);

    setState(() {
      _isLoading = false;

      // Ordena do maior para o menor valor
      _allItemsABC.sort((a, b) {
        final valorA = parseStringToDouble(a.valor.toString());
        final valorB = parseStringToDouble(b.valor.toString());
        return valorB.compareTo(valorA); // DESC
      });

      _updateVisibleItems();
    });
  }

  void _updateVisibleItems() {
    final startIndex = (_currentABCPage - 1) * _itemsABCPerPage;

    var endIndex = startIndex + _itemsABCPerPage;

    if (endIndex > _allItemsABC.length) {
      endIndex = _allItemsABC.length;
    }

    setState(() {
      _visibleItemsABC = _allItemsABC.sublist(startIndex, endIndex);
    });
  }

  void _nextPage() {
    if (_currentABCPage < _totalPages) {
      setState(() {
        _currentABCPage++;
        _updateVisibleItems();
      });
    }
  }

  void _previousPage() {
    if (_currentABCPage > 1) {
      setState(() {
        _currentABCPage--;
        _updateVisibleItems();
      });
    }
  }

  int get _totalPages {
    return (_allItemsABC.length / _itemsABCPerPage).ceil();
  }

  double parseStringToDouble(String value) {
    String formattedValue = value.replaceAll(',', '.');
    return double.tryParse(formattedValue) ?? 0.0;
  }

  Widget buildFinancialOverview(FinancialModel model) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bloco Contas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAccountColumn("Contas a receber", model.porcRecAbt, model.porcRecBx),
              _buildAccountColumn("Contas a pagar", model.porcPagAbt, model.porcPagBx),
            ],
          ),
          const SizedBox(height: 24),

          // Bloco Totais
          _buildTotalRow("Total recebimento", model.totalRec),
          _buildTotalRow("Total pagamentos", model.totalPag),
          Divider(thickness: 1),
          _buildTotalRow("Diferença", model.difRecPag, isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildAccountColumn(String title, String? aberto, String? baixado) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 6),
          Text("Em aberto: ${aberto ?? "0"}%", style: TextStyle(fontSize: 14)),
          Text("Baixados: ${baixado ?? "0"}%", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String? value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isHighlight ? Colors.green[700] : Colors.black,
              ),
            ),
          ),
          Text(
            formatCurrency(value ?? "0,0"),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financeiro', style: TextStyle(
            color: Colors.white
        ),),
        backgroundColor: Color(0xFF0511F2),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : BlocConsumer<FinancialBlocCubit, FinancialBlocState>(
              listener: (context, state) {
                // TODO: implement listener
                state.status.matchAny(
                  error: () {
                    showError(state.errorMessage ?? "Erro não Informado");
                  },
                  any: () {
                    _allItemsABC = state.financialModel.contaContabil ?? [];

                    _allItemsABC.sort((a, b) {
                      final valorA = parseStringToDouble(a.valor.toString());
                      final valorB = parseStringToDouble(b.valor.toString());
                      return valorB.compareTo(valorA);
                    });

                    _updateVisibleItems();

                  },
                );
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFinancialOverview(state.financialModel),
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
                                      touchCallback: (FlTouchEvent event,
                                          pieTouchResponse) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
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
                                            state.financialModel.totalRec ??
                                                "00.00"),
                                        parseStringToDouble(
                                            state.financialModel.totalPag ??
                                                "00.00")),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 18,
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 2,
                          children: <Widget>[
                            Indicator(
                              color: Colors.blue.shade900,
                              text:
                              "Total Recebimentos ${formatCurrency(state.financialModel.totalRec ?? "00.00")}",
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Indicator(
                              color: Colors.red.shade900,
                              text:
                              'Total Pagamentos ${formatCurrency(state.financialModel.totalPag ?? "00.00")}',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Despesas Fixas",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text('Contas a Pagar', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Total R\$', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text('Em aberto R\$', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
                            Expanded(flex: 2, child: Text('Baixados R\$', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
                          ],
                        ),
                      ),

                      // Linha de dados
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text('')),
                            Expanded(flex: 2, child: Text(formatCurrency(state.financialModel.totalDespFx ?? "0,0") , textAlign: TextAlign.end)),
                            Expanded(flex: 2, child: Text(formatCurrency(state.financialModel.totalDespFxAbt ?? "0,0"), textAlign: TextAlign.end)),
                            Expanded(flex: 2, child: Text(formatCurrency(state.financialModel.totalDespFxBx ?? "0,0"), textAlign: TextAlign.end)),
                          ],
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 0),
                                    child: LineChartWidgetBills(
                                      despesasFixas:
                                          state.financialModel.despesaFixa ??
                                              [],
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
                      //TODO: Poderia ser 1 componente
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Despesas - Conta Contábil",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: constraints.maxWidth * 0.24,
                                  columns: const [
                                    DataColumn(label: Text('Conta Contábil')),
                                    DataColumn(label: Text('Valor R\$'), numeric: true),
                                  ],
                                  rows: _visibleItemsABC.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: constraints.maxWidth * 0.34,
                                            ),
                                            child: Text(
                                              item.conta!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(formatCurrency(item.valor.toString() ?? "0,0"))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: _previousPage,
                              color: _currentABCPage == 1
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Página $_currentABCPage de $_totalPages',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: _nextPage,
                              color: _currentABCPage == _totalPages
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 16),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _itemsABCPerPage,
                                  items: [5, 10, 20, 50].map((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text('$value itens'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _itemsABCPerPage = value;
                                        _currentABCPage = 1;
                                        _updateVisibleItems();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
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
