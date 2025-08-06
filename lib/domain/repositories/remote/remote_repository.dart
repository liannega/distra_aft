import 'package:dsimcaf_1/domain/repositories/remote/usecases/activo_fijo_repository.dart';
import 'package:dsimcaf_1/domain/repositories/remote/usecases/auth_repository.dart';

abstract class RemoteRepository {
  AuthRepository get authRepository;
  ActivoRepository get activoRepository;
}
