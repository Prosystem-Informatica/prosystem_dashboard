import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/core/ui/helpers/format_money.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/comercial/cubit/commercial_bloc_cubit.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/comercial/cubit/commercial_bloc_state.dart';
import 'package:prosystem_dashboard/app/repositories/commercial/model/commercial_model.dart';

import '../../../../core/ui/helpers/messages.dart';
import '../../../../repositories/login/model/user_auth_model.dart';

class CommercialPage extends StatefulWidget {
  const CommercialPage({super.key});

  @override
  State<CommercialPage> createState() => _CommercialPageState();
}

class _CommercialPageState extends State<CommercialPage>
    with Messages<CommercialPage> {
  final UserAuthModel args =
      UserAuthModel.fromJson(jsonDecode(Get.arguments)["user"]);
  final _selectMonth = jsonDecode(Get.arguments)["mesano"];
  List<AbcProdutos> _allItemsABC = [];
  List<AbcProdutos> _visibleItemsABC = [];
  List<AbcFamilia> _allItemsFamily = [];
  List<AbcFamilia> _visibleItemsFamily = [];
  int _currentABCPage = 1;
  int _itemsABCPerPage = 10;
  int _currentFamilyPage = 1;
  int _itemsFamilyPerPage = 10;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _generateTestData();
  }

  double parseStringToDouble(String value) {
    String formattedValue = value.replaceAll(',', '.');
    return double.tryParse(formattedValue) ?? 0.0;
  }

  void _generateTestData() {
    context
        .read<CommercialBlocCubit>()
        .commercial(idempresa: args.empresa!, mesano: _selectMonth);


    _allItemsABC.sort((a, b) {
      final valorA = parseStringToDouble(a.total.toString());
      final valorB = parseStringToDouble(b.total.toString());
      return valorB.compareTo(valorA); // DESC
    });

    _allItemsFamily.sort((a, b) {
      final valorA = parseStringToDouble(a.total.toString());
      final valorB = parseStringToDouble(b.total.toString());
      return valorB.compareTo(valorA); // DESC
    });


    setState(() {
      _isLoading = false;
      _updateVisibleItems();
    });
  }

  void _updateVisibleItems() {
    final startIndex = (_currentABCPage - 1) * _itemsABCPerPage;
    final startFamilyIndex = (_currentFamilyPage - 1) * _itemsFamilyPerPage;

    var endIndex = startIndex + _itemsABCPerPage;

    var endFamilyIndex = startFamilyIndex + _itemsFamilyPerPage;

    if (endIndex > _allItemsABC.length) {
      endIndex = _allItemsABC.length;
    }

    if (endFamilyIndex > _allItemsFamily.length) {
      endFamilyIndex = _allItemsFamily.length;
    }

    setState(() {
      _visibleItemsABC = _allItemsABC.sublist(startIndex, endIndex);
      _visibleItemsFamily =
          _allItemsFamily.sublist(startFamilyIndex, endFamilyIndex);
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

  void _nextFamilyPage() {
    if (_currentFamilyPage < _totalFamilyPages) {
      setState(() {
        _currentFamilyPage++;
        _updateVisibleItems();
      });
    }
  }

  void _previousFamilyPage() {
    if (_currentFamilyPage > 1) {
      setState(() {
        _currentFamilyPage--;
        _updateVisibleItems();
      });
    }
  }

  int get _totalPages {
    return (_allItemsABC.length / _itemsABCPerPage).ceil();
  }

  int get _totalFamilyPages {
    return (_allItemsFamily.length / _itemsFamilyPerPage).ceil();
  }


  Widget buildTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget buildComercialData(CommercialModel model) {
    return Column(
      children: [
        ExpansionTile(
          title: Text("Pedidos", style: TextStyle(fontWeight: FontWeight.bold)),
          children: [
            buildTile("Quantidade", model.qtdPed ?? "0"),
            buildTile("Total", formatCurrency(model.totalPed ?? "0,0")),
            buildTile("Em aberto", model.qtdPedPend ?? "0"),
            buildTile("Total em aberto", formatCurrency(model.totalPedPend ?? "0,0")),
            buildTile("% em aberto", model.porcPedPend ?? "0%"),
            buildTile("Baixados", model.qtdPedBx ?? "0"),
            buildTile("Total baixado", formatCurrency(model.totalPedBx ?? "0,0")),
            buildTile("% baixado", model.porcPedBx ?? "0%"),
          ],
        ),
        ExpansionTile(
          title: Text("Orçamentos", style: TextStyle(fontWeight: FontWeight.bold)),
          children: [
            buildTile("Incluídos", model.qtdOrc ?? "0"),
            buildTile("Total", formatCurrency(model.totalOrc ?? "0,0")),
            buildTile("Geraram pedidos", model.qtdOrcBx ?? "0"),
            buildTile("Total pedidos", formatCurrency(model.totalOrcBx ?? "0,0")),
            buildTile("% gerado", model.porcOrcBx ?? "0%"),
            buildTile("Não realizados", model.qtdOrcPend ?? "0"),
            buildTile("Total não realizado", formatCurrency(model.totalOrcPend ?? "0,0")),
            buildTile("% não realizado", model.porcOrcPend ?? "0%"),
          ],
        ),
        ExpansionTile(
          title: Text("Pré-vendas", style: TextStyle(fontWeight: FontWeight.bold)),
          children: [
            buildTile("Incluídas", model.qtdPrePed ?? "0"),
            buildTile("Total", formatCurrency(model.totalPrePed ?? "0,0")),
            buildTile("Geraram pedidos", model.qtdPrePedBx ?? "0"),
            buildTile("Total pedidos", formatCurrency(model.totalPrePedBx ?? "0,0")),
            buildTile("% gerado", model.porcPrePedBx ?? "0%"),
            buildTile("Não realizadas", model.qtdPrePedPend ?? "0"),
            buildTile("Total não realizado", formatCurrency(model.totalPrePedPend ?? "0,0")),
            buildTile("% não realizado", model.porcPrePedPend ?? "0%"),
          ],
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comercial', style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Color(0xFF0511F2),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : BlocConsumer<CommercialBlocCubit, CommercialBlocState>(
              listener: (context, state) {
                // TODO: implement listener
                state.status.matchAny(
                  error: () {
                    showError(state.errorMessage ?? "Erro não Informado");
                  },
                  any: () {
                    _allItemsABC = state.commercialModel.abcProdutos ?? [];
                    _allItemsFamily = state.commercialModel.abcFamilia ?? [];

                    _allItemsABC.sort((a, b) {
                      final valorA = parseStringToDouble(a.total.toString());
                      final valorB = parseStringToDouble(b.total.toString());
                      return valorB.compareTo(valorA);
                    });

                    _allItemsFamily.sort((a, b) {
                      final valorA = parseStringToDouble(a.total.toString());
                      final valorB = parseStringToDouble(b.total.toString());
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
                      buildComercialData(state.commercialModel),
                      //TODO: Poderia ser 1 componente
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Curva ABC Produtos",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: constraints.maxWidth * 0.04,
                            columns: const [
                              DataColumn(label: Text('Produto')),
                              DataColumn(label: Text('Quant'), numeric: true),
                              DataColumn(
                                  label: Text('Valor R\$'), numeric: true),
                              DataColumn(label: Text('Porc(%)'), numeric: true),
                            ],
                            rows: _visibleItemsABC.map((item) {
                              return DataRow(cells: [
                                DataCell(
                                  SizedBox(
                                    width: constraints.maxWidth * 0.34,
                                    child: Text(
                                      item.produto!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.quant.toString())),
                                DataCell(Text(
                                  formatCurrency(item.total ?? "0,0"),
                                )),
                                DataCell(Text(
                                  '${item.porc!}%',
                                )),
                              ]);
                            }).toList(),
                          ),
                        );
                      }),
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
                          height: MediaQuery.of(context).size.height * 0.04),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Curva ABC por Familia",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                      //TODO: Poderia ser 1 componente
                      LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: constraints.maxWidth * 0.04,
                            columns: const [
                              DataColumn(label: Text('Produto')),
                              DataColumn(label: Text('Quant'), numeric: true),
                              DataColumn(
                                  label: Text('Valor R\$'), numeric: true),
                              DataColumn(label: Text('Porc(%)'), numeric: true),
                            ],
                            rows: _visibleItemsFamily.map((item) {
                              return DataRow(cells: [
                                DataCell(
                                  SizedBox(
                                    width: constraints.maxWidth * 0.32,
                                    child: Text(
                                      item.familia!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.quant.toString())),
                                DataCell(Text(
                                  formatCurrency(item.total ?? "0,0"),
                                )),
                                DataCell(Text(
                                  '${item.porc!}%',
                                )),
                              ]);
                            }).toList(),
                          ),
                        );
                      }),
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
                              onPressed: _previousFamilyPage,
                              color: _currentFamilyPage == 1
                                  ? Colors.grey
                                  : Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Página $_currentFamilyPage de $_totalFamilyPages',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: _nextFamilyPage,
                              color: _currentFamilyPage == _totalFamilyPages
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
}
