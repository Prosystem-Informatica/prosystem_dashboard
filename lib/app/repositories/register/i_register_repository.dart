import 'models/register_model.dart';

abstract class IRegisterRepository {
  Future<RegisterModel> register(String idempresa, String mesano);
}
