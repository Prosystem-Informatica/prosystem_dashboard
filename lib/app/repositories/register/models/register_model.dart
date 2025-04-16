class RegisterModel {
  String? clienteinc;
  String? clienteatv;
  String? clienteinatv;
  String? clienteatrasoqtd;
  String? clienteatrasovlr;
  String? geralrecatrasoqtd;
  String? geralatrasovlr;

  RegisterModel(
      {this.clienteinc,
        this.clienteatv,
        this.clienteinatv,
        this.clienteatrasoqtd,
        this.clienteatrasovlr,
        this.geralrecatrasoqtd,
        this.geralatrasovlr});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    clienteinc = json['CLIENTE_INC'];
    clienteatv = json['CLIENTE_ATV'];
    clienteinatv = json['CLIENTE_INATV'];
    clienteatrasoqtd = json['CLIENTE_ATRASO_QTD'];
    clienteatrasovlr = json['CLIENTE_ATRASO_VLR'];
    geralrecatrasoqtd = json['GERALREC_ATRASO_QTD'];
    geralatrasovlr = json['GERALREC_ATRASO_VLR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CLIENTE_INC'] = this.clienteinc;
    data['CLIENTE_ATV'] = this.clienteatv;
    data['CLIENTE_INATV'] = this.clienteinatv;
    data['CLIENTE_ATRASO_QTD'] = this.clienteatrasoqtd;
    data['CLIENTE_ATRASO_VLR'] = this.clienteatrasovlr;
    data['GERALREC_ATRASO_QTD'] = this.geralrecatrasoqtd;
    data['GERALREC_ATRASO_VLR'] = this.geralatrasovlr;
    return data;
  }

  @override
  String toString() {
    return 'RegisterModel{clienteinc: $clienteinc, clienteatv: $clienteatv, clienteinatv: $clienteinatv, clienteatrasoqtd: $clienteatrasoqtd, clienteatrasovlr: $clienteatrasovlr, geralrecatrasoqtd: $geralrecatrasoqtd, geralatrasovlr: $geralatrasovlr}';
  }
}