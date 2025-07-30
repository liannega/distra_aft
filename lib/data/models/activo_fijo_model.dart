import 'dart:convert';

import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';

class ActivoFijoModel {
  final String idregnumerico;
  final String nroinventario;
  final String denominacion;
  final String estado;
  final String entidad;
  final String arearesponsabilidad;
  final String responsable;
  final String centrocosto;
  final String grupo;
  final String estadooperacion;

  ActivoFijoModel({
    required this.idregnumerico,
    required this.nroinventario,
    required this.denominacion,
    required this.estado,
    required this.entidad,
    required this.arearesponsabilidad,
    required this.responsable,
    required this.centrocosto,
    required this.grupo,
    required this.estadooperacion,
  });

  ActivoFijo toEntity() {
    return ActivoFijo(
      idregnumerico: idregnumerico,
      nroinventario: nroinventario,
      denominacion: denominacion,
      estado: estado,
      entidad: entidad,
      arearesponsabilidad: arearesponsabilidad,
      responsable: responsable,
      centrocosto: centrocosto,
      grupo: grupo,
      estadooperacion: estadooperacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idregnumerico': idregnumerico,
      'nroinventario': nroinventario,
      'denominacion': denominacion,
      'estado': estado,
      'entidad': entidad,
      'arearesponsabilidad': arearesponsabilidad,
      'responsable': responsable,
      'centrocosto': centrocosto,
      'grupo': grupo,
      'estadooperacion': estadooperacion,
    };
  }

  factory ActivoFijoModel.fromMap(Map<String, dynamic> map) {
    return ActivoFijoModel(
      idregnumerico: map['idregnumerico'] ?? '',
      nroinventario: map['nroinventario'] ?? '',
      denominacion: map['denominacion'] ?? '',
      estado: map['estado'] ?? '',
      entidad: map['entidad'] ?? '',
      arearesponsabilidad: map['arearesponsabilidad'] ?? '',
      responsable: map['responsable'] ?? '',
      centrocosto: map['centrocosto'] ?? '',
      grupo: map['grupo'] ?? '',
      estadooperacion: map['estadooperacion'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivoFijoModel.fromJson(String source) =>
      ActivoFijoModel.fromMap(json.decode(source));
}
