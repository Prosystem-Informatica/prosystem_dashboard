class FinancialModel {
  String? totalRec;
  String? totalPag;
  String? difRecPag;
  String? porcRecBx;
  String? porcRecAbt;
  String? porcPagBx;
  String? porcPagAbt;
  String? totalDespFx;
  String? totalDespFxAbt;
  String? totalDespFxBx;
  List<ContaContabil>? contaContabil;
  List<DespesaFixa>? despesaFixa;

  FinancialModel(
      {this.totalRec,
        this.totalPag,
        this.difRecPag,
        this.porcRecBx,
        this.porcRecAbt,
        this.porcPagBx,
        this.porcPagAbt,
        this.totalDespFx,
        this.totalDespFxAbt,
        this.totalDespFxBx,
        this.contaContabil,
      this.despesaFixa});

  FinancialModel.fromJson(Map<String, dynamic> json) {
    totalRec = json['TOTALREC'];
    totalPag = json['TOTALPAG'];
    difRecPag = json['DIFRECPAG'];
    porcRecBx = json['PORCRECBX'];
    porcRecAbt = json['PORCRECABT'];
    porcPagBx = json['PORCPAGBX'];
    porcPagAbt = json['PORCPAGABT'];
    totalDespFx = json['TOTALDESPFX'];
    totalDespFxAbt = json['TOTALDESPFXABT'];
    totalDespFxBx = json['TOTALDESPFXBX'];
    if (json['CONTACONTABIL'] != null) {
      contaContabil = <ContaContabil>[];
      json['CONTACONTABIL'].forEach((v) {
        contaContabil!.add(ContaContabil.fromJson(v));
      });
    }
    if (json['DESPESAFIXA'] != null) {
      despesaFixa = <DespesaFixa>[];
    json['DESPESAFIXA'].forEach((v) {
      despesaFixa!.add(DespesaFixa.fromJson(v));
    });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TOTALREC'] = totalRec;
    data['TOTALPAG'] = totalPag;
    data['DIFRECPAG'] = difRecPag;
    data['PORCRECBX'] = porcRecBx;
    data['PORCRECABT'] = porcRecAbt;
    data['PORCPAGBX'] = porcPagBx;
    data['PORCPAGABT'] = porcPagAbt;
    data['TOTALDESPFX'] = totalDespFx;
    data['TOTALDESPFXABT'] = totalDespFxAbt;
    data['TOTALDESPFXBX'] = totalDespFxBx;
    if (contaContabil != null) {
      data['CONTACONTABIL'] = contaContabil!.map((v) => v.toJson()).toList();
    }
    if (despesaFixa != null) {
      data['DESPESAFIXA'] = despesaFixa!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'FinancialModel{totalRec: $totalRec, totalPag: $totalPag, difRecPag: $difRecPag, porcRecBx: $porcRecBx, porcRecAbt: $porcRecAbt, porcPagBx: $porcPagBx, porcPagAbt: $porcPagAbt, totalDespFx: $totalDespFx, totalDespFxAbt: $totalDespFxAbt, totalDespFxBx: $totalDespFxBx, contaContabil: $contaContabil, despesaFixa: $despesaFixa}';
  }
}

class DespesaFixa {
  String? fornecedor;
  String? valor;

  DespesaFixa({this.fornecedor, this.valor});

  DespesaFixa.fromJson(Map<String, dynamic> json) {
    fornecedor = json['FORNECEDOR'];
    valor = json['VALOR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fornecedor'] = this.fornecedor;
    data['valor'] = this.valor;
    return data;
  }

  @override
  String toString() {
    return 'DespesaFixa{fornecedor: $fornecedor, valor: $valor}';
  }
}

class ContaContabil {
  String? conta;
  String? valor;

  ContaContabil({this.conta, this.valor});

  ContaContabil.fromJson(Map<String, dynamic> json) {
    conta = json['CONTA'];
    valor = json['VALOR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CONTA'] = conta;
    data['VALOR'] = valor;
    return data;
  }
}