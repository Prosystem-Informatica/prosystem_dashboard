

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';
import 'package:prosystem_dashboard/app/repositories/technical_assistance/models/technical_assistance_model.dart';

import '../../../../../repositories/daily_payments/models/daily_payments_model.dart';

part 'technical_assistance_bloc_state.g.dart';


@match
enum TechnicalAssistanceBlocStatus { initial, loading, error, success }

class TechnicalAssistanceBlocState extends Equatable {
  final TechnichalAssistenceModel? technichalAssistenceModel;
  final TechnicalAssistanceBlocStatus status;
  final String? errorMessage;
  final String? successMessage;

  const TechnicalAssistanceBlocState({
    required this.technichalAssistenceModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  TechnicalAssistanceBlocState.initial()
      : status = TechnicalAssistanceBlocStatus.initial,
        technichalAssistenceModel = null,
        errorMessage = null,
        successMessage = null;

  @override
  List<Object?> get props => [
    technichalAssistenceModel,
    status,
    errorMessage,
    successMessage
  ];

  TechnicalAssistanceBlocState copyWith({
    TechnichalAssistenceModel? technicalAssitance,
    TechnicalAssistanceBlocStatus? status,
    String? errorMessage,
    String? successMessage
  }) {
    return TechnicalAssistanceBlocState(
        technichalAssistenceModel: technicalAssitance ?? this.technichalAssistenceModel,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage
    );
  }
}

