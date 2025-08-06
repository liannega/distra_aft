import 'dart:convert';

import 'package:dsimcaf_1/domain/entities/conteo.dart';

class ConteoModelDb {
  final String id;
  final String estado;
  final String tipo;
  final String? subtipo;
  final String? area;
  final String? responsable;
  final DateTime fechaIni;
  final DateTime? fechaFin;
  final String idUser;
  ConteoModelDb({
    required this.id,
    required this.estado,
    required this.tipo,
    this.subtipo,
    this.area,
    this.responsable,
    required this.fechaIni,
    this.fechaFin,
    required this.idUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estado': estado,
      'tipo': tipo,
      'subtipo': subtipo,
      'area': area,
      'responsable': responsable,
      'fechaIni': fechaIni.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'idUser': idUser,
    };
  }

  factory ConteoModelDb.fromMap(Map<String, dynamic> map) {
    return ConteoModelDb(
      id: map['id'] ?? '',
      estado: map['estado'] ?? '',
      tipo: map['tipo'] ?? '',
      subtipo: map['subtipo'],
      area: map['area'],
      responsable: map['responsable'],
      fechaIni: DateTime.parse(map['fechaIni']),
      fechaFin:
          map['fechaFin'] != null ? DateTime.parse(map['fechaFin']) : null,
      idUser: map['idUser'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConteoModelDb.fromJson(String source) =>
      ConteoModelDb.fromMap(json.decode(source));

  Conteo toEntity() {
    return Conteo(
      id: id,
      estado: estado,
      tipo: tipo,
      subtipo: subtipo,
      area: area,
      responsable: responsable,
      fechaIni: fechaIni,
      fechaFin: fechaFin,
      idUser: idUser,
    );
  }
}
