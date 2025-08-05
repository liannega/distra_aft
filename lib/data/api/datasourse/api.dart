import 'package:dsimcaf_1/data/api/datasourse/usecases/activo_fijo_api.dart';
import 'package:dsimcaf_1/data/api/datasourse/usecases/auth_api.dart';
import 'package:dsimcaf_1/data/myDio/my_dio.dart';
import 'package:dsimcaf_1/domain/repositories/remote/remote_repository.dart';
import 'package:dsimcaf_1/domain/repositories/remote/usecases/activo_fijo_repository.dart';
import 'package:dsimcaf_1/domain/repositories/remote/usecases/auth_repository.dart';

class Api extends RemoteRepository {

  static final RemoteRepository _instace = Api._();
  late MyDio _myDio;

  static RemoteRepository getInstance() => _instace;

  //* usecases
  late AuthApi _authApi;
  late ActivoFijoApi _activoFijoApi;

  Api._() {
    _myDio = MyDio();

    //* usecases
    _authApi = AuthApi(_myDio);
    _activoFijoApi = ActivoFijoApi(_myDio);
  }

  @override
  ActivoRepository get activoRepository => _activoFijoApi;


  @override
  AuthRepository get authRepository => _authApi;
}
