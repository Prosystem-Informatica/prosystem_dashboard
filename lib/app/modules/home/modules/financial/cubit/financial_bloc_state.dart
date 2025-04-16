

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:prosystem_dashboard/app/repositories/financial/model/financial_model.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';

import '../../../../../repositories/daily_payments/models/daily_payments_model.dart';

part 'financial_bloc_state.g.dart';

@match
enum FinancialStatus { initial, loading, error, success }

class FinancialBlocState extends Equatable {
  final FinancialModel financialModel;
  final FinancialStatus status;
  final String? errorMessage;
  final String? successMessage;

  const FinancialBlocState({
    required this.financialModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  FinancialBlocState.initial()
      : status = FinancialStatus.initial,
        financialModel = FinancialModel(),
        errorMessage = null,
        successMessage = null;

  @override
  List<Object?> get props => [
    financialModel,
    status,
    errorMessage,
    successMessage
  ];

  FinancialBlocState copyWith({
    FinancialModel? financialModel,
    FinancialStatus? status,
    String? errorMessage,
    String? successMessage
  }) {
    return FinancialBlocState(
        financialModel: financialModel ?? this.financialModel,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage
    );
  }
}

