// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension RegisterStatusMatch on RegisterStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == RegisterStatus.initial) {
      return initial();
    }

    if (v == RegisterStatus.loading) {
      return loading();
    }

    if (v == RegisterStatus.error) {
      return error();
    }

    if (v == RegisterStatus.success) {
      return success();
    }

    throw Exception('RegisterStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == RegisterStatus.initial && initial != null) {
      return initial();
    }

    if (v == RegisterStatus.loading && loading != null) {
      return loading();
    }

    if (v == RegisterStatus.error && error != null) {
      return error();
    }

    if (v == RegisterStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
