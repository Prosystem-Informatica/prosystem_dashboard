// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commercial_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension CommercialStatusMatch on CommercialStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == CommercialStatus.initial) {
      return initial();
    }

    if (v == CommercialStatus.loading) {
      return loading();
    }

    if (v == CommercialStatus.error) {
      return error();
    }

    if (v == CommercialStatus.success) {
      return success();
    }

    throw Exception('CommercialStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == CommercialStatus.initial && initial != null) {
      return initial();
    }

    if (v == CommercialStatus.loading && loading != null) {
      return loading();
    }

    if (v == CommercialStatus.error && error != null) {
      return error();
    }

    if (v == CommercialStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
