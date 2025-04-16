

import 'model/commercial_model.dart';

abstract class ICommercialRepository {
  Future<CommercialModel> commercial(String mesano, String idEmpresa);
}
