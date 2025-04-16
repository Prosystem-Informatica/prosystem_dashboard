import 'package:prosystem_dashboard/app/repositories/month_payments/models/month_payments_model.dart';


abstract class IMonthPaymentsRepository {
  Future<MonthPaymentsModel> monthPayments(String idempresa, String mesano);
}
