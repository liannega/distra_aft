import 'package:dsimcaf_1/config/constants/conteo_estado.dart';
import 'package:dsimcaf_1/config/constants/conteo_tipo.dart';
import 'package:dsimcaf_1/config/constants/db_constanst.dart';
import 'package:dsimcaf_1/config/constants/shared_prefs_key.dart';
import 'package:dsimcaf_1/config/utils/generate_id.dart';
import 'package:dsimcaf_1/data/database/models_db/conteo_model_db.dart';
import 'package:dsimcaf_1/data/sqlite_handlers/sqlite_handler.dart';
import 'package:dsimcaf_1/domain/entities/conteo.dart';
import 'package:dsimcaf_1/domain/repositories/local/usecases/conteo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConteoDb extends ConteoRepository {
  final SqliteHandler _sqliteHandler;
  ConteoDb(this._sqliteHandler);

  Future<List<Conteo>> _getAllConteos(String estado) async {
    try {
      final res = await _sqliteHandler.query(
        DbConstanst.conteoTable,
        where: 'estado = ?',
        whereArgs: [estado],
      );
      return res.map((e) => ConteoModelDb.fromMap(e).toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching conteos: $e');
    }
  }

  @override
  Future<bool> createConteoGeneral() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsKey.currentUserIdkey);
      final fechaIni = DateTime.now();
      return await _sqliteHandler.insert(
        DbConstanst.conteoTable,
        ConteoModelDb(
          id: GenerateId.generateId(),
          estado: ConteoEstado.enProceso,
          tipo: ConteoTipo.general,
          subtipo: null,
          area: null,
          responsable: null,
          fechaIni: fechaIni,
          fechaFin: null,
          idUser: userId ?? '',
        ).toMap(),
      );
    } catch (e) {
      print('waka Error creating conteo general: $e');
      throw Exception('Error creating conteo general: $e');
    }
  }

  @override
  Future<List<Conteo>> getConteosPlanificados() {
    return _getAllConteos(ConteoEstado.planificado);
  }

  @override
  Future<List<Conteo>> getConteosProcesos() {
    return _getAllConteos(ConteoEstado.enProceso);
  }

  @override
  Future<List<Conteo>> getConteosTerminados() {
    return _getAllConteos(ConteoEstado.terminado);
  }

  @override
  Future<bool> deleteConteo(String conteoId) {
    try {
      return _sqliteHandler.delete(
        DbConstanst.conteoTable,
        where: 'id = ?',
        whereArgs: [conteoId],
      );
    } catch (e) {
      // print('Error deleting conteo: $e');
      throw Exception('Error deleting conteo: $e');
    }
  }

  @override
  Future<bool> updateEstadoConteo(String conteoId, String newEstado) {
    try {
      return _sqliteHandler.update(
        DbConstanst.conteoTable,
        {'estado': newEstado},
        where: 'id = ?',
        whereArgs: [conteoId],
      );
    } catch (e) {
      // print('Error deleting conteo: $e');
      throw Exception('Error deleting conteo: $e');
    }
  }
}
