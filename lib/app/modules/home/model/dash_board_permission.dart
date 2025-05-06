class DashboardPermissions {
  final bool faturamentoDiario;
  final bool faturamentoMensal;
  final bool cadastro;
  final bool comercial;
  final bool financeiro;
  final bool pagamentosDiarios;
  final bool assistenciaTecnica;

  DashboardPermissions({
    required this.faturamentoDiario,
    required this.faturamentoMensal,
    required this.cadastro,
    required this.comercial,
    required this.financeiro,
    required this.pagamentosDiarios,
    required this.assistenciaTecnica,
  });

  factory DashboardPermissions.fromString(String permissionString) {
    if (permissionString.length != 7) {
      return DashboardPermissions(
        faturamentoDiario: false,
        faturamentoMensal: false,
        cadastro: false,
        comercial: false,
        financeiro: false,
        pagamentosDiarios: false,
        assistenciaTecnica: false,
      );
    }

    return DashboardPermissions(
      faturamentoDiario: permissionString[0] == 'T',
      faturamentoMensal: permissionString[1] == 'T',
      cadastro: permissionString[2] == 'T',
      comercial: permissionString[3] == 'T',
      financeiro: permissionString[4] == 'T',
      pagamentosDiarios: permissionString[5] == 'T',
      assistenciaTecnica: permissionString[6] == 'T',
    );
  }

  // Método para serialização em JSON
  Map<String, dynamic> toJson() {
    return {
      'faturamentoDiario': faturamentoDiario,
      'faturamentoMensal': faturamentoMensal,
      'cadastro': cadastro,
      'comercial': comercial,
      'financeiro': financeiro,
      'pagamentosDiarios': pagamentosDiarios,
      'assistenciaTecnica': assistenciaTecnica,
    };
  }

  // Método para converter para string (formato original)
  @override
  String toString() {
    return '${faturamentoDiario ? 'T' : 'F'}'
        '${faturamentoMensal ? 'T' : 'F'}'
        '${cadastro ? 'T' : 'F'}'
        '${comercial ? 'T' : 'F'}'
        '${financeiro ? 'T' : 'F'}'
        '${pagamentosDiarios ? 'T' : 'F'}'
        '${assistenciaTecnica ? 'T' : 'F'}';
  }
}