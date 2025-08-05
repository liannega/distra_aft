class ConteoItemModelDb {
  String id;
  String estado;
  String idMedio;
  String conteoId;
  String? observacion;

  ConteoItemModelDb({
    required this.id,
    required this.estado,
    required this.idMedio,
    required this.conteoId,
    this.observacion,
  });


}
