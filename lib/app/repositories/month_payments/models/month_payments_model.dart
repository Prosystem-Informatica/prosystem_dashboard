class MonthPaymentsModel {
  String? meta;
  String? metaparcial;
  String? total1;
  String? total2;
  String? total3;
  String? total4;
  String? total5;
  List<REPRESENTANTES>? representantes;

  MonthPaymentsModel(
      {this.meta,
        this.metaparcial,
        this.total1,
        this.total2,
        this.total3,
        this.total4,
        this.total5,
        this.representantes});

  MonthPaymentsModel.fromJson(Map<String, dynamic> json) {
    meta = json['META'];
    metaparcial = json['META_PARCIAL'];
    total1 = json['TOTAL-1'];
    total2 = json['TOTAL-2'];
    total3 = json['TOTAL-3'];
    total4 = json['TOTAL-4'];
    total5 = json['TOTAL-5'];
    if (json['REPRESENTANTES'] != null) {
      representantes = <REPRESENTANTES>[];
      json['REPRESENTANTES'].forEach((v) {
        representantes!.add(new REPRESENTANTES.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['META'] = this.meta;
    data['META_PARCIAL'] = this.metaparcial;
    data['TOTAL-1'] = this.total1;
    data['TOTAL-2'] = this.total2;
    data['TOTAL-3'] = this.total3;
    data['TOTAL-4'] = this.total4;
    data['TOTAL-5'] = this.total5;
    if (this.representantes != null) {
      data['REPRESENTANTES'] =
          this.representantes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'MonthPaymentsModel{meta: $meta, metaparcial: $metaparcial, total1: $total1, total2: $total2, total3: $total3, total4: $total4, total5: $total5, representantes: $representantes}';
  }
}

class REPRESENTANTES {
  String? nome;
  String? total;

  REPRESENTANTES({this.nome, this.total});

  REPRESENTANTES.fromJson(Map<String, dynamic> json) {
    nome = json['NOME'];
    total = json['TOTAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NOME'] = this.nome;
    data['TOTAL'] = this.total;
    return data;
  }

  @override
  String toString() {
    return 'REPRESENTANTES{nome: $nome, total: $total}';
  }
}
