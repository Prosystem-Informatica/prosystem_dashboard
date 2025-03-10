class ValidationModel{
  String? codigo;
  String? empresa;
  String? servidor;
  String? porta;
  String? validado;

  ValidationModel({this.codigo, this.empresa, this.servidor, this.porta, this.validado });

  ValidationModel.fromJson(Map<String, dynamic> json) {
    codigo = json['CODIGO'];
    empresa = json['EMPRESA'];
    servidor = json['SERVIDOR'];
    porta = json['PORTA'];
    validado = json['VALIDADO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.codigo;
    data['EMPRESA'] = this.empresa;
    data['SERVIDOR'] = this.servidor;
    data['PORTA'] = this.porta;
    data['VALIDADO'] = this.validado;
    return data;
  }

  @override
  String toString() {
    return 'ValidationModel{codigo: $codigo, empresa: $empresa, servidor: $servidor, porta: $porta, validado: $validado}';
  }
}