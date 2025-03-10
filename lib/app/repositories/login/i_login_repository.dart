
import 'package:prosystem_dashboard/app/repositories/login/model/user_auth_model.dart';
import 'package:prosystem_dashboard/app/repositories/login/model/validation_model.dart';

abstract class ILoginRepository {
  Future<ValidationModel> login(String cnpj);
  Future<List<UserAuthModel>> loginUser(String port, String username, String password);
}
