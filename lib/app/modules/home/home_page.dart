import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/payment_daily_page.dart';

import '../../repositories/login/model/user_auth_model.dart';
import 'modules/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserAuthModel args = Get.arguments;

  int _currentIndex = 0;

  final List<Widget> _children = [
    Dashboard(userAuthModel: Get.arguments,),
    PaymentDailyPage(),
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
        title: Text(args.fantasia!),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Faturamento Diario',
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
  String? _selectedMonth;
  final List<String> _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedMonth,
            hint: Text('Selecione um mês'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMonth = newValue;
              });
              print('Mês selecionado: $_selectedMonth');
            },
            items: _months.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          _buildSummaryCard(),
          SizedBox(height: 16),
          _buildChart(),

        ],
      ),
    );
  }
}

Widget _buildSummaryCard() {
  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Faturamento do Mês", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Valor Parcial: R\$ 2.032.335,05", style: TextStyle(fontSize: 16)),
          Text("Dias Úteis: 23", style: TextStyle(fontSize: 16)),
        ],
      ),
    ),
  );
}

Widget _buildChart() {
  return Expanded(
    child: Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Faturamento Últimos 5 Meses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 2.6, color: Colors.blue)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2.4, color: Colors.green)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2.7, color: Colors.purple)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 2.1, color: Colors.orange)]),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (double value, TitleMeta meta) {
                      String text;
                      switch (value.toInt()) {
                        case 0:
                          text = 'Dez';
                          break;
                        case 1:
                          text = 'Nov';
                          break;
                        case 2:
                          text = 'Out';
                          break;
                        case 3:
                          text = 'Set';
                          break;
                        default:
                          text = '';
                          break;
                      }
                      return Text(text, style: TextStyle(fontSize: 12));
                    })),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


