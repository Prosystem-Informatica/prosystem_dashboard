// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension FinancialStatusMatch on FinancialStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == FinancialStatus.initial) {
      return initial();
    }

    if (v == FinancialStatus.loading) {
      return loading();
    }

    if (v == FinancialStatus.error) {
      return error();
    }

    if (v == FinancialStatus.success) {
      return success();
    }

    throw Exception('FinancialStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == FinancialStatus.initial && initial != null) {
      return initial();
    }

    if (v == FinancialStatus.loading && loading != null) {
      return loading();
    }

    if (v == FinancialStatus.error && error != null) {
      return error();
    }

    if (v == FinancialStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
