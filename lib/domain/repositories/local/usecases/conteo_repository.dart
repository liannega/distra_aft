import 'package:dsimcaf_1/domain/entities/conteo.dart';

abstract class ConteoRepository {
  Future<List<Conteo>> getConteosProcesos();
  Future<List<Conteo>> getConteosPlanificados();
  Future<List<Conteo>> getConteosTerminados();
  Future<bool> createConteoGeneral();
}
