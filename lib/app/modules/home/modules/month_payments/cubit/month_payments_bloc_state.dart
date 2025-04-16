

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:prosystem_dashboard/app/repositories/month_payments/models/month_payments_model.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';

part 'month_payments_bloc_state.g.dart';


@match
enum MonthPaymentsStatus { initial, loading, error, success }

class MonthPaymentsBlocState extends Equatable {
  final MonthPaymentsModel? monthPaymentsModel;
  final MonthPaymentsStatus status;
  final String? errorMessage;
  final String? successMessage;

  const MonthPaymentsBlocState({
    required this.monthPaymentsModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  MonthPaymentsBlocState.initial()
      : status = MonthPaymentsStatus.initial,
        monthPaymentsModel = null,
        errorMessage = null,
        successMessage = null;

  @override
  List<Object?> get props => [
    monthPaymentsModel,
    status,
    errorMessage,
    successMessage
  ];

  MonthPaymentsBlocState copyWith({
    MonthPaymentsModel? monthPaymentsModel,
    MonthPaymentsStatus? status,
    String? errorMessage,
    String? successMessage
  }) {
    return MonthPaymentsBlocState(
        monthPaymentsModel: monthPaymentsModel ?? this.monthPaymentsModel,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage
    );
  }
}

