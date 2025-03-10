import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';

abstract class IPaymentDailyRepository {
  Future<PaymentDailyModel> paymentDaily(String idempresa, String mesano);
}
