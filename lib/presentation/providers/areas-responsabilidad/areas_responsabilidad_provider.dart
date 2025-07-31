import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';
import 'package:dsimcaf_1/domain/repositories/usecases/activo_fijo_repository.dart';
import 'package:dsimcaf_1/presentation/providers/data/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final areasResponsabilidadProvider = StateNotifierProvider.autoDispose<
  AreasResponsabilidadNotifier,
  AreasResponsabilidadState
>((ref) {
  return AreasResponsabilidadNotifier(ref.read(apiProvider).activoRepository);
});

class AreasResponsabilidadNotifier
    extends StateNotifier<AreasResponsabilidadState> {
  AreasResponsabilidadNotifier(this._activoRepository)
    : super(AreasResponsabilidadState()) {
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

class AreasResponsabilidadState {
  final List<ActivoFijo> activosFijos;
  final bool isLoading;
  final String? error;
  AreasResponsabilidadState({
    this.activosFijos = const [],
    this.isLoading = false,
    this.error,
  });
  List<String> get areasUnicas {
    final set = <String>{};
    for (final af in activosFijos) {
      if (af.arearesponsabilidad.isNotEmpty) {
        set.add(af.arearesponsabilidad);
      }
    }
    return set.toList()..sort();
  }

  int get totalAreas => areasUnicas.length;
  Map<String, List<ActivoFijo>> get groupedByArea {
    final map = <String, List<ActivoFijo>>{};
    for (final af in activosFijos) {
      final area = af.arearesponsabilidad;
      if (area.isNotEmpty) {
        map.putIfAbsent(area, () => []);
        map[area]!.add(af);
      }
    }
    return map;
  }

  AreasResponsabilidadState copyWith({
    List<ActivoFijo>? activosFijos,
    bool? isLoading,
    ValueGetter<String?>? error,
  }) {
    return AreasResponsabilidadState(
      activosFijos: activosFijos ?? this.activosFijos,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
    );
  }
}
