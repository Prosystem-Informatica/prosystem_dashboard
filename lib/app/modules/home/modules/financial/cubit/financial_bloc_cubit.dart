import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prosystem_dashboard/app/repositories/financial/financial_repository.dart';

import 'financial_bloc_state.dart';

class FinancialBlocCubit extends Cubit<FinancialBlocState> {
  final FinancialRepository financialRepository;
  FinancialBlocCubit({required this.financialRepository})
      : super(FinancialBlocState.initial());

  Future<void> financial({required String mesano, required String idempresa}) async {
    try {
      emit(
        state.copyWith(
          status: FinancialStatus.loading,
        ),
      );
      final financial = await financialRepository.financial(mesano, idempresa);

      emit(
        state.copyWith(
            status: FinancialStatus.success,
            financialModel: financial,
            successMessage: "Busca realizada"
        ),
      );

    } on Exception {
      emit(
        state.copyWith(
          status: FinancialStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }
}
