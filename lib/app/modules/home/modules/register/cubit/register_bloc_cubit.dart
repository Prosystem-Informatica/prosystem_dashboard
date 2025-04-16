import 'package:bloc/bloc.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/register/cubit/register_bloc_state.dart';

import '../../../../../repositories/register/register_repository.dart';


class RegisterCubit extends Cubit<RegisterBlocState> {
  final RegisterRepository registerRepository;
  RegisterCubit({required this.registerRepository})
      : super(RegisterBlocState.initial());

  Future<void> register({required String idempresa,required String mesano}) async {
    try {
      emit(
        state.copyWith(
          status: RegisterStatus.loading,
        ),
      );
      final register = await registerRepository.register(idempresa, mesano);

      print("Oq tem no cubit ${register.toString()}");

      emit(
        state.copyWith(
            status: RegisterStatus.success,
            registerModel: register,
            successMessage: "Busca realizada"
        ),
      );

    } on Exception {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: "Erro ao buscar informações",
        ),
      );
    } catch(e) {
      print("Error > $e");
    }
  }

}