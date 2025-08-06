import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';
import 'package:dsimcaf_1/domain/repositories/remote/usecases/activo_fijo_repository.dart';
import 'package:dsimcaf_1/presentation/providers/data/api_provider.dart';

final submayorAFTProvider =
    StateNotifierProvider.autoDispose<SubmayorAFTNotifier, SubmayorAFTState>((
      ref,
    ) {
      return SubmayorAFTNotifier(ref.read(apiProvider).activoRepository);
    });

class SubmayorAFTNotifier extends StateNotifier<SubmayorAFTState> {
  SubmayorAFTNotifier(this._activoRepository) : super(SubmayorAFTState()) {
    loadActivosFijos();
  }

  final ActivoRepository _activoRepository;

  void loadActivosFijos() async {
    state = state.copyWith(isLoading: true, error: () => null);

    final res = await _activoRepository.getActivos(
      tipo: 1,
      codigoEntidad: '10',
    );

    if (res.isOk) {
      state = state.copyWith(activosFijos: res.data ?? [], isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: () => res.message ?? 'Error al cargar los activos fijos',
      );
    }
  }
}

class SubmayorAFTState {
  final List<ActivoFijo> activosFijos;
  final bool isLoading;
  final String? error;
  SubmayorAFTState({
    this.activosFijos = const [],
    this.isLoading = false,
    this.error,
  });

  SubmayorAFTState copyWith({
    List<ActivoFijo>? activosFijos,
    bool? isLoading,
    ValueGetter<String?>? error,
  }) {
    return SubmayorAFTState(
      activosFijos: activosFijos ?? this.activosFijos,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }
}
