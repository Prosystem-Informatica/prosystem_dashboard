

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';

import '../../../../../repositories/daily_payments/models/daily_payments_model.dart';

part 'daily_payments_bloc_state.g.dart';


@match
enum DailyPaymentsStatus { initial, loading, error, success }

class DailyPaymentsBlocState extends Equatable {
  final List<DailyPaymentsModel>? dailyPaymentsModel;
  final DailyPaymentsStatus status;
  final String? errorMessage;
  final String? successMessage;

  const DailyPaymentsBlocState({
    required this.dailyPaymentsModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  DailyPaymentsBlocState.initial()
      : status = DailyPaymentsStatus.initial,
        dailyPaymentsModel = [],
        errorMessage = null,
        successMessage = null;

  @override
  List<Object?> get props => [
    dailyPaymentsModel,
    status,
    errorMessage,
    successMessage
  ];

  DailyPaymentsBlocState copyWith({
    List<DailyPaymentsModel>? dailyPaymentsModel,
    DailyPaymentsStatus? status,
    String? errorMessage,
    String? successMessage
  }) {
    return DailyPaymentsBlocState(
        dailyPaymentsModel: dailyPaymentsModel ?? this.dailyPaymentsModel,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage
    );
  }
}

