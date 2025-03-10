

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';

part 'payment_daily_bloc_state.g.dart';


@match
enum PaymentDailyStatus { initial, loading, error, success }

class PaymentDailyBlocState extends Equatable {
  final PaymentDailyModel? paymentDailyModel;
  final PaymentDailyStatus status;
  final String? errorMessage;
  final String? successMessage;

  const PaymentDailyBlocState({
    required this.paymentDailyModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  PaymentDailyBlocState.initial()
      : status = PaymentDailyStatus.initial,
        paymentDailyModel = PaymentDailyModel(metadodia: "0", metaparcial: "0"),
        errorMessage = null,
        successMessage = null;

  @override
  List<Object?> get props => [
    paymentDailyModel,
    status,
    errorMessage,
    successMessage
  ];

  PaymentDailyBlocState copyWith({
    PaymentDailyModel? paymentDailyModel,
    PaymentDailyStatus? status,
    String? errorMessage,
    String? successMessage
  }) {
    return PaymentDailyBlocState(
        paymentDailyModel: paymentDailyModel ?? this.paymentDailyModel,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage
    );
  }
}

