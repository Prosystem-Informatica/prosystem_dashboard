// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_payments_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension MonthPaymentsStatusMatch on MonthPaymentsStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == MonthPaymentsStatus.initial) {
      return initial();
    }

    if (v == MonthPaymentsStatus.loading) {
      return loading();
    }

    if (v == MonthPaymentsStatus.error) {
      return error();
    }

    if (v == MonthPaymentsStatus.success) {
      return success();
    }

    throw Exception(
        'MonthPaymentsStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == MonthPaymentsStatus.initial && initial != null) {
      return initial();
    }

    if (v == MonthPaymentsStatus.loading && loading != null) {
      return loading();
    }

    if (v == MonthPaymentsStatus.error && error != null) {
      return error();
    }

    if (v == MonthPaymentsStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
