class TechnichalAssistenceModel {
  String? totalAssistencia;
  String? totalAssispend;
  String? totalAssisbx;
  List<AbcAssistencia>? abcAssistencia;

  TechnichalAssistenceModel(
      {this.totalAssistencia,
      this.totalAssispend,
      this.totalAssisbx,
      this.abcAssistencia});

  TechnichalAssistenceModel.fromJson(Map<String, dynamic> json) {
    totalAssistencia = json['TOTAL_ASSISTENCIA'];
    totalAssispend = json['TOTAL_ASSISPEND'];
    totalAssisbx = json['TOTAL_ASSISBX'];
    if (json['ABCASSISTENCIA'] != null) {
      abcAssistencia = <AbcAssistencia>[];
      json['ABCASSISTENCIA'].forEach((v) {
        abcAssistencia!.add(new AbcAssistencia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TOTAL_ASSISTENCIA'] = this.totalAssistencia;
    data['TOTAL_ASSISPEND'] = this.totalAssispend;
    data['TOTAL_ASSISBX'] = this.totalAssisbx;
    if (this.abcAssistencia != null) {
      data['ABCASSISTENCIA'] =
          this.abcAssistencia!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'TechnichalAssistenceModel{totalAssistencia: $totalAssistencia, totalAssispend: $totalAssispend, totalAssisbx: $totalAssisbx, abcAssistencia: $abcAssistencia}';
  }
}

class AbcAssistencia {
  String? produto;
  String? quant;
  String? porc;

  AbcAssistencia({this.produto, this.quant, this.porc});

  AbcAssistencia.fromJson(Map<String, dynamic> json) {
    produto = json['PRODUTO'];
    quant = json['QUANT'];
    porc = json['PORC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PRODUTO'] = this.produto;
    data['QUANT'] = this.quant;
    data['PORC'] = this.porc;
    return data;
  }
}
