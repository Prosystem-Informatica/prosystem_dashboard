class CommercialModel {
  String? qtdPed;
  String? totalPed;
  String? qtdPedBx;
  String? totalPedBx;
  String? porcPedBx;
  String? qtdPedPend;
  String? totalPedPend;
  String? porcPedPend;
  String? qtdOrc;
  String? totalOrc;
  String? qtdOrcBx;
  String? totalOrcBx;
  String? porcOrcBx;
  String? qtdOrcPend;
  String? totalOrcPend;
  String? porcOrcPend;
  String? qtdPrePed;
  String? totalPrePed;
  String? qtdPrePedBx;
  String? totalPrePedBx;
  String? porcPrePedBx;
  String? qtdPrePedPend;
  String? totalPrePedPend;
  String? porcPrePedPend;
  List<AbcProdutos>? abcProdutos;
  List<AbcFamilia>? abcFamilia;

  CommercialModel(
      {this.qtdPed,
        this.totalPed,
        this.qtdPedBx,
        this.totalPedBx,
        this.porcPedBx,
        this.qtdPedPend,
        this.totalPedPend,
        this.porcPedPend,
        this.qtdOrc,
        this.totalOrc,
        this.qtdOrcBx,
        this.totalOrcBx,
        this.porcOrcBx,
        this.qtdOrcPend,
        this.totalOrcPend,
        this.porcOrcPend,
        this.qtdPrePed,
        this.totalPrePed,
        this.qtdPrePedBx,
        this.totalPrePedBx,
        this.porcPrePedBx,
        this.qtdPrePedPend,
        this.totalPrePedPend,
        this.porcPrePedPend,
        this.abcProdutos,
        this.abcFamilia});

  CommercialModel.fromJson(Map<String, dynamic> json) {
    qtdPed = json['QTDPED'];
    totalPed = json['TOTALPED'];
    qtdPedBx = json['QTDPEDBX'];
    totalPedBx = json['TOTALPEDBX'];
    porcPedBx = json['PORCPEDBX'];
    qtdPedPend = json['QTDPEDPEND'];
    totalPedPend = json['TOTALPEDPEND'];
    porcPedPend = json['PORCPEDPEND'];
    qtdOrc = json['QTDORC'];
    totalOrc = json['TOTALORC'];
    qtdOrcBx = json['QTDORCBX'];
    totalOrcBx = json['TOTALORCBX'];
    porcOrcBx = json['PORCORCBX'];
    qtdOrcPend = json['QTDORCPEND'];
    totalOrcPend = json['TOTALORCPEND'];
    porcOrcPend = json['PORCORCPEND'];
    qtdPrePed = json['QTDPREPED'];
    totalPrePed = json['TOTALPREPED'];
    qtdPrePedBx = json['QTDPREPEDBX'];
    totalPrePedBx = json['TOTALPREPEDBX'];
    porcPrePedBx = json['PORCPREPEDBX'];
    qtdPrePedPend = json['QTDPREPEDPEND'];
    totalPrePedPend = json['TOTALPREPEDPEND'];
    porcPrePedPend = json['PORCPREPEDPEND'];
    if (json['ABCPRODUTOS'] != null) {
      abcProdutos = <AbcProdutos>[];
      json['ABCPRODUTOS'].forEach((v) {
        abcProdutos!.add(AbcProdutos.fromJson(v));
      });
    }
    if (json['ABCFAMILIA'] != null) {
      abcFamilia = <AbcFamilia>[];
      json['ABCFAMILIA'].forEach((v) {
        abcFamilia!.add(AbcFamilia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['QTDPED'] = qtdPed;
    data['TOTALPED'] = totalPed;
    data['QTDPEDBX'] = qtdPedBx;
    data['TOTALPEDBX'] = totalPedBx;
    data['PORCPEDBX'] = porcPedBx;
    data['QTDPEDPEND'] = qtdPedPend;
    data['TOTALPEDPEND'] = totalPedPend;
    data['PORCPEDPEND'] = porcPedPend;
    data['QTDORC'] = qtdOrc;
    data['TOTALORC'] = totalOrc;
    data['QTDORCBX'] = qtdOrcBx;
    data['TOTALORCBX'] = totalOrcBx;
    data['PORCORCBX'] = porcOrcBx;
    data['QTDORCPEND'] = qtdOrcPend;
    data['TOTALORCPEND'] = totalOrcPend;
    data['PORCORCPEND'] = porcOrcPend;
    data['QTDPREPED'] = qtdPrePed;
    data['TOTALPREPED'] = totalPrePed;
    data['QTDPREPEDBX'] = qtdPrePedBx;
    data['TOTALPREPEDBX'] = totalPrePedBx;
    data['PORCPREPEDBX'] = porcPrePedBx;
    data['QTDPREPEDPEND'] = qtdPrePedPend;
    data['TOTALPREPEDPEND'] = totalPrePedPend;
    data['PORCPREPEDPEND'] = porcPrePedPend;
    if (abcProdutos != null) {
      data['ABCPRODUTOS'] = abcProdutos!.map((v) => v.toJson()).toList();
    }
    if (abcFamilia != null) {
      data['ABCFAMILIA'] = abcFamilia!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'CommercialModel{qtdPed: $qtdPed, totalPed: $totalPed, qtdPedBx: $qtdPedBx, totalPedBx: $totalPedBx, porcPedBx: $porcPedBx, qtdPedPend: $qtdPedPend, totalPedPend: $totalPedPend, porcPedPend: $porcPedPend, qtdOrc: $qtdOrc, totalOrc: $totalOrc, qtdOrcBx: $qtdOrcBx, totalOrcBx: $totalOrcBx, porcOrcBx: $porcOrcBx, qtdOrcPend: $qtdOrcPend, totalOrcPend: $totalOrcPend, porcOrcPend: $porcOrcPend, qtdPrePed: $qtdPrePed, totalPrePed: $totalPrePed, qtdPrePedBx: $qtdPrePedBx, totalPrePedBx: $totalPrePedBx, porcPrePedBx: $porcPrePedBx, qtdPrePedPend: $qtdPrePedPend, totalPrePedPend: $totalPrePedPend, porcPrePedPend: $porcPrePedPend, abcProdutos: $abcProdutos, abcFamilia: $abcFamilia}';
  }
}

class AbcProdutos {
  String? produto;
  String? quant;
  String? total;
  String? porc;

  AbcProdutos({this.produto, this.quant, this.total, this.porc});

  AbcProdutos.fromJson(Map<String, dynamic> json) {
    produto = json['PRODUTO'];
    quant = json['QUANT'];
    total = json['TOTAL'];
    porc = json['PORC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PRODUTO'] = produto;
    data['QUANT'] = quant;
    data['TOTAL'] = total;
    data['PORC'] = porc;
    return data;
  }

  @override
  String toString() {
    return 'AbcProdutos{produto: $produto, quant: $quant, total: $total, porc: $porc}';
  }
}

class AbcFamilia {
  String? familia;
  String? quant;
  String? total;
  String? porc;

  AbcFamilia({this.familia, this.quant, this.total, this.porc});

  AbcFamilia.fromJson(Map<String, dynamic> json) {
    familia = json['FAMILIA'];
    quant = json['QUANT'];
    total = json['TOTAL'];
    porc = json['PORC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FAMILIA'] = familia;
    data['QUANT'] = quant;
    data['TOTAL'] = total;
    data['PORC'] = porc;
    return data;
  }

  @override
  String toString() {
    return 'AbcFamilia{familia: $familia, quant: $quant, total: $total, porc: $porc}';
  }
}