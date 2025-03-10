// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_daily_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension PaymentDailyStatusMatch on PaymentDailyStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == PaymentDailyStatus.initial) {
      return initial();
    }

    if (v == PaymentDailyStatus.loading) {
      return loading();
    }

    if (v == PaymentDailyStatus.error) {
      return error();
    }

    if (v == PaymentDailyStatus.success) {
      return success();
    }

    throw Exception(
        'PaymentDailyStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == PaymentDailyStatus.initial && initial != null) {
      return initial();
    }

    if (v == PaymentDailyStatus.loading && loading != null) {
      return loading();
    }

    if (v == PaymentDailyStatus.error && error != null) {
      return error();
    }

    if (v == PaymentDailyStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
