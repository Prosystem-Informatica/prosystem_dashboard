import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/payment_daily/cubit/payment_daily_bloc_state.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/payment_daily_repository.dart';


class PaymentDailyCubit extends Cubit<PaymentDailyBlocState> {
  final PaymentDailyRepository paymentDailyRepository;
  PaymentDailyCubit({required this.paymentDailyRepository})
      : super(PaymentDailyBlocState.initial());

  Future<void> paymentDaily({required String idempresa,required String mesano}) async {
    try {
      emit(
        state.copyWith(
          status: PaymentDailyStatus.loading,
        ),
      );
      final payment = await paymentDailyRepository.paymentDaily(idempresa, mesano);

        emit(
          state.copyWith(
              status: PaymentDailyStatus.success,
              paymentDailyModel: payment,
              successMessage: "Busca realizada"
          ),
        );

    } on Exception {
      emit(
        state.copyWith(
          status: PaymentDailyStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }

}