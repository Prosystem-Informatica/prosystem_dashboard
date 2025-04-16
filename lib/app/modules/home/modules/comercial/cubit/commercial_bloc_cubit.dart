import 'package:bloc/bloc.dart';

import '../../../../../repositories/commercial/commercial_repository.dart';
import 'commercial_bloc_state.dart';

class CommercialBlocCubit extends Cubit<CommercialBlocState> {
  final CommercialRepository commercialRepository;
  CommercialBlocCubit({required this.commercialRepository})
      : super(CommercialBlocState.initial());

  Future<void> commercial({required String mesano, required String idempresa}) async {
    try {
      emit(
        state.copyWith(
          status: CommercialStatus.loading,
        ),
      );
      final commercial = await commercialRepository.commercial(mesano, idempresa);

      emit(
        state.copyWith(
            status: CommercialStatus.success,
            commercialModel: commercial,
            successMessage: "Busca realizada"
        ),
      );

    } on Exception {
      emit(
        state.copyWith(
          status: CommercialStatus.error,
          errorMessage: "Erro ao efetuar Login",
        ),
      );
    }
  }
}
