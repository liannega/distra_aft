import 'package:dsimcaf_1/data/api/models/activo_fijo_model.dart';
import 'package:dsimcaf_1/data/myDio/custom_response.dart';
import 'package:dsimcaf_1/data/myDio/my_dio.dart';
import 'package:dsimcaf_1/data/placeholder/activos_placeholder.dart';
import 'package:dsimcaf_1/data/placeholder/uh_placeholder.dart';
import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';
import 'package:dsimcaf_1/domain/repositories/remote/usecases/activo_fijo_repository.dart';

class ActivoFijoApi extends ActivoRepository {
  final MyDio _dio;
  ActivoFijoApi(this._dio);

  final String localPath = "transp";

  @override
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
  }) async {
    try {
      // final response = await _dio.request(
      //   requestType: RequestType.GET,
      //   path: '$localPath/submayor-aft',
      //   queryParameters: {
      //     'tipo': tipo,
      //     if (codigoEntidad != null) 'codigo_entidad': codigoEntidad,
      //     if (codigo != null) 'codigo': codigo,
      //     if (denominacion != null) 'denominacion': denominacion,
      //     if (nroSerie != null) 'nro_serie': nroSerie,
      //     if (nroInventario !== null)
      //       'area_responsabilidad': areaResponsabilidad,
      //     if (marca != null) 'marca': marca,
      //     if (modelo != null) 'modelo': modelo,
      //   },
      // );
      final response = tipo == 1 ? activoPlaceholder : uhPlaceholder;
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      final data = response['data'] as Map<String, dynamic>;
      final items = data['items'] as List;

      return CustomResponse(
        statusCode: 200,
        data: items.map((e) => ActivoFijoModel.fromMap(e).toEntity()).toList(),
      );
    } on CustomDioError catch (e) {
      return CustomResponse(statusCode: e.code, message: e.message);
    } catch (e) {
      return CustomResponse(statusCode: 400, message: e.toString());
    }
  }
}
