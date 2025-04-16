import 'package:bloc/bloc.dart';

import '../../../../../repositories/daily_payments/daily_payments_repository.dart';
import 'daily_payments_bloc_state.dart';


class DailyPaymentsCubit extends Cubit<DailyPaymentsBlocState> {
  final DailyPaymentsRepository dailyPaymentsRepository;
  DailyPaymentsCubit({required this.dailyPaymentsRepository})
      : super(DailyPaymentsBlocState.initial());

  Future<void> dailyPayments({required String idempresa}) async {
    try {
      emit(
        state.copyWith(
          status: DailyPaymentsStatus.loading,
        ),
      );
      final payment = await dailyPaymentsRepository.dailyPayments(idempresa);

      emit(
        state.copyWith(
            status: DailyPaymentsStatus.success,
            dailyPaymentsModel: payment,
            successMessage: "Busca realizada"
        ),
      );

    } on Exception {
      emit(
        state.copyWith(
          status: DailyPaymentsStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }

}