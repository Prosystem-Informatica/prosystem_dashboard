import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/modules/home/model/dash_board_permission.dart';
import '../../repositories/login/model/user_auth_model.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserAuthModel args = Get.arguments;
  int _currentIndex = 0;

  final List<Widget> _children = [
    Dashboard(userAuthModel: Get.arguments),
    ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        fixedColor: Color(0xFF0511F2),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  final UserAuthModel userAuthModel;
  const Dashboard({required this.userAuthModel, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final UserAuthModel args = Get.arguments;
  DateTime? _selectedDate;
  String? _selectMonth;
  List<Map<String, dynamic>> _availableMonths = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _updateMonthYear();
    _generateAvailableMonths();
  }

  void _updateMonthYear() {
    if (_selectedDate != null) {
      String formattedMonth = _selectedDate!.month.toString().padLeft(2, '0');
      String formattedYear = _selectedDate!.year.toString();
      _selectMonth = "$formattedMonth$formattedYear";
    }
  }

  void _generateAvailableMonths() {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 3, 1, 1);
    final lastDate = now;

    List<Map<String, dynamic>> months = [];

    for (int year = lastDate.year; year >= firstDate.year; year--) {
      int maxMonth = (year == lastDate.year) ? lastDate.month : 12;

      for (int month = maxMonth; month >= 1; month--) {
        months.add({
          'year': year,
          'month': month,
          'date': DateTime(year, month),
          'disabled': false,
        });
      }
    }

    setState(() {
      _availableMonths = months;
    });
  }

  Future<void> _showMonthYearPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar', style: TextStyle(fontSize: 18)),
                  ),
                  Text(
                    'Selecione Mês e Ano',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                        _updateMonthYear();
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Hoje', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              Divider(thickness: 1.5),
              SizedBox(height: 12),
              Expanded(
                child: _availableMonths.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _availableMonths.length,
                        itemBuilder: (context, index) {
                          final item = _availableMonths[index];
                          final isSelected = _selectedDate != null &&
                              _selectedDate!.year == item['year'] &&
                              _selectedDate!.month == item['month'];

                          return ListTile(
                            title: Text(
                              "${item['year']} | ${_getMonthName(item['month'])}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Color(0xFF0511F2)
                                    : Colors.black,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check, color: Color(0xFF0511F2))
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedDate = item['date'];
                                _updateMonthYear();
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  Widget _buildSummaryCard(String title, String route) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.45,
      height: 170,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(route,
              arguments: jsonEncode(
                  {"user": widget.userAuthModel, "mesano": _selectMonth}));
        },
        child: Card(
          elevation: 4,
          color: Color(0xFF0511F2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text("Clique para mais informações",
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalScrollList() {
    final permissions = widget.userAuthModel.dashboardPermissions;

    print("Oq temos aq > ${permissions.toString()}");
    final cards = <Widget>[];

    if (permissions?.faturamentoDiario ?? false) {
      cards.add(_buildSummaryCard("Faturamento Diario", "/daily"));
    }
    if (permissions?.faturamentoMensal ?? false) {
      cards.add(_buildSummaryCard("Faturamento Mensal", "/month"));
    }
    if (permissions?.cadastro ?? false) {
      cards.add(_buildSummaryCard("Cadastro", "/register"));
    }
    if (permissions?.comercial ?? false) {
      cards.add(_buildSummaryCard("Comercial", "/commercial"));
    }
    if (permissions?.financeiro ?? false) {
      cards.add(_buildSummaryCard("Financeiro", "/financial"));
    }
    if (permissions?.pagamentosDiarios ?? false) {
      cards.add(_buildSummaryCard("Pagamentos Diarios", "/payments"));
    }
    if (permissions?.assistenciaTecnica ?? false) {
      cards.add(_buildSummaryCard("Assistencia Tecnica", "/technical"));
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.751,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    children: cards,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMonthYearPicker(context),
        backgroundColor: Color(0xFF0511F2),
        child: Icon(Icons.calendar_month, color: Colors.white,),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg-login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildHorizontalScrollList(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
