// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_assistance_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension TechnicalAssistanceBlocStatusMatch on TechnicalAssistanceBlocStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success}) {
    final v = this;
    if (v == TechnicalAssistanceBlocStatus.initial) {
      return initial();
    }

    if (v == TechnicalAssistanceBlocStatus.loading) {
      return loading();
    }

    if (v == TechnicalAssistanceBlocStatus.error) {
      return error();
    }

    if (v == TechnicalAssistanceBlocStatus.success) {
      return success();
    }

    throw Exception(
        'TechnicalAssistanceBlocStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success}) {
    final v = this;
    if (v == TechnicalAssistanceBlocStatus.initial && initial != null) {
      return initial();
    }

    if (v == TechnicalAssistanceBlocStatus.loading && loading != null) {
      return loading();
    }

    if (v == TechnicalAssistanceBlocStatus.error && error != null) {
      return error();
    }

    if (v == TechnicalAssistanceBlocStatus.success && success != null) {
      return success();
    }

    return any();
  }
}
