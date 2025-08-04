// ignore_for_file: unused_field, deprecated_member_use

import 'package:dsimcaf_1/presentation/widgets/area_selelection.dart';
import 'package:dsimcaf_1/presentation/widgets/confirmacion_conteo.dart';
import 'package:dsimcaf_1/presentation/widgets/selection_custodio_modal.dart';
import 'package:dsimcaf_1/presentation/widgets/slccion_responsable_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NuevoConteoModal extends ConsumerStatefulWidget {
  final String tipoMedio;
  final VoidCallback onClose;

  const NuevoConteoModal({
    super.key,
    required this.tipoMedio,
    required this.onClose,
  });

  @override
  ConsumerState<NuevoConteoModal> createState() => _NuevoConteoModalState();
}

class _NuevoConteoModalState extends ConsumerState<NuevoConteoModal> {
  String? _tipoConteoSeleccionado;
  Map<String, dynamic>? _criteriosSeleccionados;

  void _seleccionarTipoConteo(String tipo) {
    setState(() {
      _tipoConteoSeleccionado = tipo;
      _criteriosSeleccionados = null;
    });

    switch (tipo) {
      case 'general':
        _mostrarConfirmacionConteo({
          'tipo': 'General',
          'descripcion':
              'Conteo del 100% de los medios, para todas las áreas de responsabilidad',
          'centroCosto': '101-Administración',
          'cantidadMedios': widget.tipoMedio == 'AFT' ? 14499 : 892,
        });
        break;
      case 'parcial_mensual':
        _mostrarPlanesConteo();
        break;
      case 'personalizado':
        _mostrarOpcionesPersonalizadas();
        break;
    }
  }

  void _mostrarPlanesConteo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPlanesConteoModal(),
    );
  }

  void _mostrarOpcionesPersonalizadas() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOpcionesPersonalizadasModal(),
    );
  }

  void _seleccionarCriterioPersonalizado(String criterio) {
    Navigator.pop(context); // Cerrar modal de opciones

    switch (criterio) {
      case 'area':
        _mostrarSeleccionArea();
        break;
      case 'responsable':
        _mostrarSeleccionResponsable();
        break;
      case 'custodio':
        _mostrarSeleccionCustodio();
        break;
    }
  }

  void _mostrarSeleccionArea() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SeleccionAreaModal(
            onAreaSeleccionada: (area) {
              Navigator.pop(context);
              _mostrarConfirmacionConteo({
                'tipo': 'Parcial personalizado por: Área de responsabilidad',
                'descripcion':
                    'Conteo del 100% de los medios asociados a un área de responsabilidad',
                'area': area['name'],
                'codigo': area['code'],
                'cantidadMedios': area['assetsCount'],
              });
            },
            onClose: () => Navigator.pop(context),
          ),
    );
  }

  void _mostrarSeleccionResponsable() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SeleccionResponsableModal(
            onResponsableSeleccionado: (responsable) {
              Navigator.pop(context);
              _mostrarConfirmacionConteo({
                'tipo': 'Parcial personalizado por: Responsable de área',
                'descripcion':
                    'Conteo de todos los medios definidos para un responsable de área',
                'responsable': responsable['name'],
                'cantidadMedios': responsable['totalAssets'],
              });
            },
            onClose: () => Navigator.pop(context),
          ),
    );
  }

  void _mostrarSeleccionCustodio() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => SeleccionCustodioModal(
            onCustodioSeleccionado: (custodio) {
              Navigator.pop(context);
              _mostrarConfirmacionConteo({
                'tipo': 'Parcial personalizado por: Custodio de medio',
                'descripcion':
                    'Conteo de todos los medios asignados a un custodio',
                'custodio': custodio['name'],
                'cantidadMedios': custodio['totalAssets'],
              });
            },
            onClose: () => Navigator.pop(context),
          ),
    );
  }

  void _mostrarConfirmacionConteo(Map<String, dynamic> criterios) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => ConfirmacionConteoModal(
            tipoMedio: widget.tipoMedio,
            criterios: criterios,
            onConfirmar: () {
              Navigator.pop(context);
              widget.onClose();
              _iniciarConteo(criterios);
            },
            onCancelar: () => Navigator.pop(context),
          ),
    );
  }

  void _iniciarConteo(Map<String, dynamic> criterios) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Conteo iniciado: ${criterios['tipo']}')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adicionar conteo  ${widget.tipoMedio}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Selecciona el tipo de conteo a realizar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 24,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),

            // Opciones de conteo
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildOpcionConteo(
                    'general',
                    'General',
                    'Conteo del 100% de los medios, para todas las áreas de responsabilidad',
                    Icons.business_center,
                    const Color(0xFF8B5CF6),
                  ),
                  const SizedBox(height: 16),
                  _buildOpcionConteo(
                    'parcial_mensual',
                    'Parcial mensual',
                    'Conteo planificado según plan mensual',
                    Icons.calendar_month,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 16),
                  _buildOpcionConteo(
                    'personalizado',
                    'Parcial personalizado',
                    'Conteo sobre criterios definidos por el usuario',
                    Icons.person_outline,
                    const Color(0xFF10B981),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionConteo(
    String id,
    String titulo,
    String descripcion,
    IconData icono,
    Color color,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _seleccionarTipoConteo(id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icono, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanesConteoModal() {
    final planes = [
      {
        'area': 'AIRES ACONDICIONADOS INSTALACIONES',
        'mes': 'Enero',
        'porcentaje': 10,
        'cantidadMedios': 11,
      },
      {
        'area': 'TEATRO ZONA 5 INFRAESTRUCTURA',
        'mes': 'Enero',
        'porcentaje': 15,
        'cantidadMedios': 18,
      },
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      'Planes de conteo mensual',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: planes.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final plan = planes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _mostrarConfirmacionConteo({
                          'tipo': 'Parcial mensual',
                          'descripcion': 'Conteo planificado',
                          'area': plan['area'],
                          'mes': plan['mes'],
                          'porcentaje': plan['porcentaje'],
                          'cantidadMedios': plan['cantidadMedios'],
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan['area'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text('Mes: ${plan['mes']}'),
                                const SizedBox(width: 16),
                                Text('${plan['porcentaje']}%'),
                                const Spacer(),
                                Text('${plan['cantidadMedios']} medios'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionesPersonalizadasModal() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      'Conteo personalizado por:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildCriterioPersonalizado(
                    'area',
                    'Área de responsabilidad',
                    'Conteo del 100% de los medios asociados a un área',
                    Icons.location_on,
                    const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 12),
                  _buildCriterioPersonalizado(
                    'responsable',
                    'Responsable de área',
                    'Conteo de todos los medios de un responsable',
                    Icons.person,
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 12),
                  _buildCriterioPersonalizado(
                    'custodio',
                    'Custodio de medio',
                    'Conteo de todos los medios asignados a un custodio',
                    Icons.security,
                    const Color(0xFFFF9800),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCriterioPersonalizado(
    String id,
    String titulo,
    String descripcion,
    IconData icono,
    Color color,
  ) {
    return InkWell(
      onTap: () => _seleccionarCriterioPersonalizado(id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icono, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
