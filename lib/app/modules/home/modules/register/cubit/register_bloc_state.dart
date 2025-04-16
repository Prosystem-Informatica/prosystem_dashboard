

import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:prosystem_dashboard/app/repositories/payment_daily/models/payment_daily_model.dart';

import '../../../../../repositories/register/models/register_model.dart';

part 'register_bloc_state.g.dart';


@match
enum RegisterStatus { initial, loading, error, success }

class RegisterBlocState extends Equatable {
  final RegisterModel? registerModel;
  final RegisterStatus status;
  final String? errorMessage;
  final String? successMessage;

  const RegisterBlocState({
    required this.registerModel,
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  const RegisterBlocState.initial()
      : status = RegisterStatus.initial,
        registerModel = null,
        errorMessage = null,
        successMessage = null;

  @override
  List<Object?> get props => [
    registerModel,
    status,
    errorMessage,
    successMessage
  ];

  RegisterBlocState copyWith({
    RegisterModel? registerModel,
    RegisterStatus? status,
    String? errorMessage,
    String? successMessage
  }) {
    return RegisterBlocState(
        registerModel: registerModel ?? this.registerModel,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage
    );
  }
}

