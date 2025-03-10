import 'package:bloc/bloc.dart';
import 'package:prosystem_dashboard/app/modules/login/cubit/login_bloc_state.dart';
import 'package:prosystem_dashboard/app/repositories/login/login_repository.dart';
import 'package:prosystem_dashboard/app/repositories/login/model/validation_model.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  final LoginRepository loginRepository;
  LoginBlocCubit({required this.loginRepository})
      : super(LoginBlocState.initial());

  Future<void> login(String cnpj) async {
    try {
      emit(
        state.copyWith(
          status: LoginStateStatus.loading,
        ),
      );
      final loginValidation = await loginRepository.login(cnpj);

      if (loginValidation.codigo == "0") {
        emit(
          state.copyWith(
              status: LoginStateStatus.error,
              validationModel: loginValidation,
              errorMessage: "CNPJ não validado"),
        );
      } else {
        emit(
          state.copyWith(
            status: LoginStateStatus.success,
            validationModel: loginValidation,
            successMessage: "CNPJ Validado"
          ),
        );
      }
    } on Exception {
      emit(
        state.copyWith(
          status: LoginStateStatus.error,
          validationModel: ValidationModel(),
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }

  Future<void> loginUser(String port, String username, String password) async {
    try {
      emit(
        state.copyWith(
          status: LoginStateStatus.loading,
        ),
      );
      final loginValidation =
          await loginRepository.loginUser(port, username, password);

      bool isValid =
          loginValidation.any((validation) => validation.codigo != "0");

      if (isValid) {
        emit(
          state.copyWith(
              status: LoginStateStatus.success, userAuthModel: loginValidation, successMessage: "Login Realizado com Sucesso!!"),
        );
      } else {
        emit(
          state.copyWith(
              status: LoginStateStatus.error,
              userAuthModel: [],
              errorMessage: "Usuario não autorizado"),
        );
      }
    } on Exception {
      emit(
        state.copyWith(
            status: LoginStateStatus.error,
            errorMessage: "Erro ao efetuar Login",
            userAuthModel: []),
      );
    }
  }
}
