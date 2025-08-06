import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dsimcaf_1/domain/entities/conteo.dart';
import 'package:dsimcaf_1/domain/repositories/local/usecases/conteo_repository.dart';
import 'package:dsimcaf_1/presentation/providers/data/db_provider.dart';

final conteoAftProvider =
    StateNotifierProvider.autoDispose<ConteoAftNotifier, ConteoAftState>((ref) {
      return ConteoAftNotifier(ref.read(dbProvider).conteoRepository);
    });

class ConteoAftNotifier extends StateNotifier<ConteoAftState> {
  ConteoAftNotifier(this._conteoRepository) : super(ConteoAftState()) {
    init();
  }

  final ConteoRepository _conteoRepository;
  TabController? tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  void init() async {
    await fetchConteosProcesos();
    await fetchConteosPlanificados();
    await fetchConteosTerminados();
  }

  Future<void> fetchConteosProcesos() async {
    final conteos = await _conteoRepository.getConteosProcesos();
    state = state.copyWith(conteosProceso: conteos);
  }

  Future<void> fetchConteosPlanificados() async {
    final conteos = await _conteoRepository.getConteosPlanificados();
    state = state.copyWith(conteosPlanificados: conteos);
  }

  Future<void> fetchConteosTerminados() async {
    final conteos = await _conteoRepository.getConteosTerminados();
    state = state.copyWith(conteosTerminados: conteos);
  }

  Future<void> createNuevoConteoGeneral() async {
    final isOk = await _conteoRepository.createConteoGeneral();
    if (isOk) {
      fetchConteosProcesos();
    } else {
      // print('Error al crear conteo general');
    }
  }

  Future<void> deleteConteo(String conteoId) async {
    final isOk = await _conteoRepository.deleteConteo(conteoId);
    if (isOk) {
      fetchConteosProcesos();
      fetchConteosPlanificados();
      fetchConteosTerminados();
    } else {
      // print('Error al eliminar conteo');
    }
  }

  Future<void> updateConteoEstado(String conteoId, String estado) async {
    final isOk = await _conteoRepository.updateEstadoConteo(conteoId, estado);
    if (isOk) {
      fetchConteosProcesos();
      fetchConteosPlanificados();
      fetchConteosTerminados();
    } else {
      // print('Error al eliminar conteo');
    }
  }

  void initTabController(conteoAFTPageState) {
    tabController = TabController(length: 3, vsync: conteoAFTPageState);

    tabController?.addListener(() {
      state = state.copyWith(currentIndex: tabController!.index);
    });
  }

  void handleSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }
}

class ConteoAftState {
  final int currentIndex;
  final String searchQuery;
  final List<Conteo> conteosProceso;
  final List<Conteo> conteosPlanificados;
  final List<Conteo> conteosTerminados;
  ConteoAftState({
    this.currentIndex = 0,
    this.searchQuery = '',
    this.conteosProceso = const [],
    this.conteosPlanificados = const [],
    this.conteosTerminados = const [],
  });

  ConteoAftState copyWith({
    int? currentIndex,
    String? searchQuery,
    List<Conteo>? conteosProceso,
    List<Conteo>? conteosPlanificados,
    List<Conteo>? conteosTerminados,
  }) {
    return ConteoAftState(
      currentIndex: currentIndex ?? this.currentIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      conteosProceso: conteosProceso ?? this.conteosProceso,
      conteosPlanificados: conteosPlanificados ?? this.conteosPlanificados,
      conteosTerminados: conteosTerminados ?? this.conteosTerminados,
    );
  }
}
