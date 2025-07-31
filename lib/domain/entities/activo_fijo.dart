class ActivoFijo {
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

  ActivoFijo({
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
  // Getter: ¿Es AFT?
  bool get esAFT => grupo == 'AFT';

  // Getter: ¿Es UH?
  bool get esUH => grupo == 'UH';
}
