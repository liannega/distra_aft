import 'package:dsimcaf_1/data/database/datasourse/db.dart';
import 'package:dsimcaf_1/domain/repositories/local/local_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dbProvider = Provider<LocalRepository>((ref) {
  return Db();
});
