class PaymentDailyModel {
  String? metadodia;
  String? metaparcial;
  String? qtdpedidos;
  String? ttpedidos;
  String? qtdcheques;
  String? ttcheques;
  String? qtdchequesbx;
  String? ttchequesbx;
  String? qtdchequesab;
  String? ttchequesab;

  PaymentDailyModel(
      {this.metadodia,
        this.metaparcial,
        this.qtdpedidos,
        this.ttpedidos,
        this.qtdcheques,
        this.ttcheques,
        this.qtdchequesbx,
        this.ttchequesbx,
        this.qtdchequesab,
        this.ttchequesab});

  PaymentDailyModel.fromJson(Map<String, dynamic> json) {
    metadodia = json['META_DO_DIA'];
    metaparcial = json['META_PARCIAL'];
    qtdpedidos = json['QTDPEDIDOS'];
    ttpedidos = json['TTPEDIDOS'];
    qtdcheques = json['QTDCHEQUES'];
    ttcheques = json['TTCHEQUES'];
    qtdchequesbx = json['QTDCHEQUESBX'];
    ttchequesbx = json['TTCHEQUESBX'];
    qtdchequesab = json['QTDCHEQUESAB'];
    ttchequesab = json['TTCHEQUESAB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['META_DO_DIA'] = this.metadodia;
    data['META_PARCIAL'] = this.metaparcial;
    data['QTDPEDIDOS'] = this.qtdpedidos;
    data['TTPEDIDOS'] = this.ttpedidos;
    data['QTDCHEQUES'] = this.qtdcheques;
    data['TTCHEQUES'] = this.ttcheques;
    data['QTDCHEQUESBX'] = this.qtdchequesbx;
    data['TTCHEQUESBX'] = this.ttchequesbx;
    data['QTDCHEQUESAB'] = this.qtdchequesab;
    data['TTCHEQUESAB'] = this.ttchequesab;
    return data;
  }
}