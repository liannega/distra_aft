import 'package:dsimcaf_1/domain/repositories/usecases/activo_fijo_repository.dart';
import 'package:dsimcaf_1/presentation/providers/data/api_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';

final submayorUHProvider =
    StateNotifierProvider<SubmayorUHNotifier, SubmayorUHState>((ref) {
      return SubmayorUHNotifier(ref.read(apiProvider).activoRepository);
    });

class SubmayorUHNotifier extends StateNotifier<SubmayorUHState> {
  SubmayorUHNotifier(this._activoRepository) : super(SubmayorUHState()) {
    loadActivosFijos();
  }
  final ActivoRepository _activoRepository;

  void loadActivosFijos() async {
    state = state.copyWith(isLoading: true, error: () => null);

    final res = await _activoRepository.getActivos(
      tipo: 2,
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

class SubmayorUHState {
  final List<ActivoFijo> activosFijos;
  final bool isLoading;
  final String? error;
  SubmayorUHState({
    this.activosFijos = const [],
    this.isLoading = false,
    this.error,
  });

  SubmayorUHState copyWith({
    List<ActivoFijo>? activosFijos,
    bool? isLoading,
    ValueGetter<String?>? error,
  }) {
    return SubmayorUHState(
      activosFijos: activosFijos ?? this.activosFijos,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }
}
