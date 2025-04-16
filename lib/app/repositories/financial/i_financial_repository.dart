
import 'model/financial_model.dart';

abstract class IFinancialRepository {
  Future<FinancialModel> financial(String mesano, String idEmpresa);
}
