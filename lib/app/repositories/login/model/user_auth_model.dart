class UserAuthModel {
  String? codigo;
  String? validado;
  String? empresa;
  String? fantasia;

  UserAuthModel({this.codigo, this.validado, this.empresa, this.fantasia});

  UserAuthModel.fromJson(Map<String, dynamic> json) {
    codigo = json['CODIGO'];
    validado = json['VALIDADO'];
    empresa = json['EMPRESA'];
    fantasia = json['FANTASIA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.codigo;
    data['VALIDADO'] = this.validado;
    data['EMPRESA'] = this.empresa;
    data['FANTASIA'] = this.fantasia;
    return data;
  }

  @override
  String toString() {
    return 'UserAuthModel{codigo: $codigo, validado: $validado, empresa: $empresa, fantasia: $fantasia}';
  }
}
