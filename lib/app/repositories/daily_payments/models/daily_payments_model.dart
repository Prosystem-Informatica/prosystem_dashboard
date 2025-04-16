class DailyPaymentsModel {
  String? fornecedor;
  String? pagontem;
  String? paghoje;
  String? pagamanha;

  DailyPaymentsModel(
      {this.fornecedor, this.pagontem, this.paghoje, this.pagamanha});

  DailyPaymentsModel.fromJson(Map<String, dynamic> json) {
    fornecedor = json['FORNEECDOR'];
    pagontem = json['PAG_ONTEM'];
    paghoje = json['PAG_HOJE'];
    pagamanha = json['PAG_AMANHA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FORNEECDOR'] = this.fornecedor;
    data['PAG_ONTEM'] = this.pagontem;
    data['PAG_HOJE'] = this.paghoje;
    data['PAG_AMANHA'] = this.pagamanha;
    return data;
  }
  static List<DailyPaymentsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DailyPaymentsModel.fromJson(json)).toList();
  }
}