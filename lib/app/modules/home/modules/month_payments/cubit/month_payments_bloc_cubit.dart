import 'package:bloc/bloc.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/month_payments/cubit/month_payments_bloc_state.dart';
import 'package:prosystem_dashboard/app/repositories/month_payments/month_payments_repository.dart';


class MonthPaymentsBlocCubit extends Cubit<MonthPaymentsBlocState> {
  final MonthPaymentsRepository monthPaymentsRepository;
  MonthPaymentsBlocCubit({required this.monthPaymentsRepository})
      : super(MonthPaymentsBlocState.initial());

  Future<void> paymentDaily({required String idempresa,required String mesano}) async {
    try {
      emit(
        state.copyWith(
          status: MonthPaymentsStatus.loading,
        ),
      );
      final payment = await monthPaymentsRepository.monthPayments(idempresa, mesano);



      emit(
        state.copyWith(
            status: MonthPaymentsStatus.success,
            monthPaymentsModel: payment,
            successMessage: "Busca realizada"
        ),
      );

    } on Exception {
      emit(
        state.copyWith(
          status: MonthPaymentsStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }

}