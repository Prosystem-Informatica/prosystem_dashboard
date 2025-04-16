import 'package:prosystem_dashboard/app/repositories/technical_assistance/models/technical_assistance_model.dart';

abstract class ITechnicalAssistanceRepository {
  Future<TechnichalAssistenceModel> technicalAssistance(String mesano, String idempresa);
}
