// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_payments_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension DailyPaymentsStatusMatch on DailyPaymentsStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == DailyPaymentsStatus.initial) {
      return initial();
    }

    if (v == DailyPaymentsStatus.loading) {
      return loading();
    }

    if (v == DailyPaymentsStatus.error) {
      return error();
    }

    if (v == DailyPaymentsStatus.success) {
      return success();
    }

    throw Exception(
        'DailyPaymentsStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == DailyPaymentsStatus.initial && initial != null) {
      return initial();
    }

    if (v == DailyPaymentsStatus.loading && loading != null) {
      return loading();
    }

    if (v == DailyPaymentsStatus.error && error != null) {
      return error();
    }

    if (v == DailyPaymentsStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
