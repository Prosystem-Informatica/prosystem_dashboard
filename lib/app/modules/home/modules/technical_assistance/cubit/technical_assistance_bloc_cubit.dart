import 'package:bloc/bloc.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/technical_assistance/cubit/technical_assistance_bloc_state.dart';
import 'package:prosystem_dashboard/app/repositories/technical_assistance/technical_assistance_repository.dart';

import '../../../../../repositories/daily_payments/daily_payments_repository.dart';


class TechnicalAssistanceBlocCubit extends Cubit<TechnicalAssistanceBlocState> {
  final TechnicalAssistanceRepository technicalAssistanceRepository;
  TechnicalAssistanceBlocCubit({required this.technicalAssistanceRepository})
      : super(TechnicalAssistanceBlocState.initial());

  Future<void> technicalAssistance({required String mesano, required String idempresa}) async {
    try {
      emit(
        state.copyWith(
          status: TechnicalAssistanceBlocStatus.loading,
        ),
      );
      final tech = await technicalAssistanceRepository.technicalAssistance(mesano, idempresa);

      print("Oq tem no tech ${tech}");

      emit(
        state.copyWith(
            status: TechnicalAssistanceBlocStatus.success,
            successMessage: "Busca realizada",
          technicalAssitance: tech
        ),
      );

    } on Exception {
      emit(
        state.copyWith(
          status: TechnicalAssistanceBlocStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }

}