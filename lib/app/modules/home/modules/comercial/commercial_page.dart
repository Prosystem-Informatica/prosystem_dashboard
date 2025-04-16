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

  void _generateTestData() {
    context
        .read<CommercialBlocCubit>()
        .commercial(idempresa: args.empresa!, mesano: _selectMonth);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comercial'),
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
                    _updateVisibleItems();
                  },
                );
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Quant de pedidos : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdPed ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text(formatCurrency(state.commercialModel.totalPed ?? "0,0"),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                            Row(
                              children: [
                                Text(
                                  "Quant de pedidos em aberto : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdPedPend ?? "0",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text("${formatCurrency(state.commercialModel.totalPedPend ?? "0,0") ?? ""} ${state.commercialModel.porcPedPend}"),
                            Row(
                              children: [
                                Text(
                                  "Quant de pedidos baixados : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdPedBx ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text("${formatCurrency(state.commercialModel.totalPedBx ?? "0,00")} ${state.commercialModel.porcPedBx}"),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Orçamentos incluidos : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdOrc ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text(formatCurrency(state.commercialModel.totalOrc ?? "0,0"),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                            Row(
                              children: [
                                Text(
                                  "Orçamento gerado pedidos : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdOrcPend ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text("${formatCurrency(state.commercialModel.totalOrcPend ?? "0,0")} ${state.commercialModel.porcOrcPend}"),
                            Row(
                              children: [
                                Text(
                                  "Orçamentos não realizado : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdOrcBx ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text("${formatCurrency(state.commercialModel.totalOrcBx ?? "0,0")} ${state.commercialModel.porcOrcBx}"),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Pre venda incluidas : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdPrePed ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text("${formatCurrency(state.commercialModel.totalPrePed ?? "0,0")} ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                            Row(
                              children: [
                                Text(
                                  "Pre vendas gerada pedidos : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdPrePedBx ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text("${formatCurrency(state.commercialModel.totalPrePedBx ?? "0,0")} ${state.commercialModel.porcPrePedBx}"),
                            Row(
                              children: [
                                Text(
                                  "Pre vendas não realizadas : ",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.commercialModel.qtdPrePedPend ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Text("${formatCurrency(state.commercialModel.totalPrePedPend ?? "0,0")}  ${state.commercialModel.porcPrePedPend}")

                          ],
                        ),
                      ),
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
                            columnSpacing: constraints.maxWidth * 0.06,
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
                                    width: constraints.maxWidth * 0.36,
                                    child: Text(
                                      item.produto!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.quant.toString())),
                                DataCell(Text(
                                  'R\$${item.total!}',
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
                            columnSpacing: constraints.maxWidth * 0.05,
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
                                    width: constraints.maxWidth * 0.36,
                                    child: Text(
                                      item.familia!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.quant.toString())),
                                DataCell(Text(
                                  'R\$${item.total!}',
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
