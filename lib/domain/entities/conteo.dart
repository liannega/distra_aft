class Conteo {
  final String id;
  final String estado;
  final String tipo;
  final String? subtipo;
  final String? area;
  final String? responsable;
  final DateTime fechaIni;
  final DateTime? fechaFin;
  final String idUser;
  Conteo({
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

}
