import 'package:dsimcaf_1/data/database/datasourse/usecases/conteo_db.dart';
import 'package:dsimcaf_1/data/sqlite_handlers/sqlite_handler.dart';
import 'package:dsimcaf_1/domain/repositories/local/local_repository.dart';
import 'package:dsimcaf_1/domain/repositories/local/usecases/conteo_repository.dart';

class Db extends LocalRepository {
  final SqliteHandler _sqliteHandler = SqliteHandler();

  //* usecases
  late ConteoDb _conteoDb;

  Db() {
    _conteoDb = ConteoDb(_sqliteHandler);
  }

  @override
  ConteoRepository get conteoRepository => _conteoDb;
}
