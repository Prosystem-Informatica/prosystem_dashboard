import 'package:prosystem_dashboard/app/modules/home/model/dash_board_permission.dart';

class UserAuthModel {
  String? codigo;
  String? validado;
  String? empresa;
  String? fantasia;
  DashboardPermissions? dashboardPermissions;

  UserAuthModel({
    this.codigo,
    this.validado,
    this.empresa,
    this.fantasia,
    this.dashboardPermissions,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      codigo: json['CODIGO'],
      validado: json['VALIDADO'],
      empresa: json['EMPRESA'],
      fantasia: json['FANTASIA'],
      dashboardPermissions: json['DASHBOARD'] != null
          ? DashboardPermissions.fromString(json['DASHBOARD'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODIGO': codigo,
      'VALIDADO': validado,
      'EMPRESA': empresa,
      'FANTASIA': fantasia,
      'DASHBOARD': dashboardPermissions?.toString(), // Converte as permissões para string
    };
  }

  @override
  String toString() {
    return 'UserAuthModel{'
        'codigo: $codigo, '
        'validado: $validado, '
        'empresa: $empresa, '
        'fantasia: $fantasia, '
        'dashboardPermissions: ${dashboardPermissions?.toString()}'
        '}';
  }
}