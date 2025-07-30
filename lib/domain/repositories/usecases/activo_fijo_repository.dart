import 'package:dsimcaf_1/data/myDio/custom_response.dart';
import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';

abstract class ActivoRepository {
  Future<CustomResponse<List<ActivoFijo>>> getActivos({
    required int tipo,
   required String codigoEntidad,
    String? codigo,
    String? denominacion,
    String? nroSerie,
    String? nroInventario,
    String? responsable,
    String? estadoOperacion,
    String? estadoTecnico,
    String? areaResponsabilidad,
    String? marca,
    String? modelo,
  });
}
