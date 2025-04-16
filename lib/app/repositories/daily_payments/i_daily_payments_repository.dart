import 'models/daily_payments_model.dart';

abstract class IDailyPaymentsRepository {
  Future<List<DailyPaymentsModel>> dailyPayments(String idempresa);
}
