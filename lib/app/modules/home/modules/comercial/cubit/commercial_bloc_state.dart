

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import '../../../../../repositories/commercial/model/commercial_model.dart';

part 'commercial_bloc_state.g.dart';

@match
enum CommercialStatus { initial, loading, error, success }

class CommercialBlocState extends Equatable {
  final CommercialModel commercialModel;
  final CommercialStatus status;
  final String? errorMessage;
  final String? successMessage;

  const CommercialBlocState({
    required this.commercialModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  CommercialBlocState.initial()
      : status = CommercialStatus.initial,
        commercialModel = CommercialModel(),
        errorMessage = null,
        successMessage = null;

  @override
  List<Object?> get props => [
    commercialModel,
    status,
    errorMessage,
    successMessage
  ];

  CommercialBlocState copyWith({
    CommercialModel? commercialModel,
    CommercialStatus? status,
    String? errorMessage,
    String? successMessage
  }) {
    return CommercialBlocState(
        commercialModel: commercialModel ?? this.commercialModel,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage
    );
  }
}

