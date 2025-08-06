// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/config/constants/conteo_estado.dart';
import 'package:dsimcaf_1/domain/entities/conteo.dart';
import 'package:dsimcaf_1/presentation/providers/conteo_aft/conteo_aft_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConteoCard extends StatelessWidget {
  final Conteo conteo;

  final Color color;

  const ConteoCard({
    super.key,
    this.color = const Color(0xFF3B82F6),
    required this.conteo, // Azul default
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              children: [
                Icon(Icons.assignment, color: color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    conteo.tipo.toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    conteo.estado.toString().toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detalles
            _buildDetailRow(
              Icons.location_on_outlined,
              'Área',
              conteo.area ?? 'N/A',
            ),
            _buildDetailRow(
              Icons.person_outline,
              'Responsable',
              conteo.responsable ?? 'N/A',
            ),
            _buildDetailRow(
              Icons.calendar_today,
              'Inicio',
              _formatDate(conteo.fechaIni),
            ),
            _buildDetailRow(
              Icons.event_available,
              'Fin',
              conteo.fechaFin != null
                  ? _formatDate(conteo.fechaFin!)
                  : 'Pendiente',
            ),
            Consumer(
              builder: (_, WidgetRef ref, __) {
                return IconButton(
                  onPressed: () {
                    ref
                        .read(conteoAftProvider.notifier)
                        .deleteConteo(conteo.id);
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red[600]),
                );
              },
            ),
            Consumer(
              builder: (_, WidgetRef ref, __) {
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(conteoAftProvider.notifier)
                            .updateConteoEstado(
                              conteo.id,
                              ConteoEstado.enProceso.toString(),
                            );
                      },
                      icon: Icon(Icons.edit, color: Colors.green[600]),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(conteoAftProvider.notifier)
                            .updateConteoEstado(
                              conteo.id,
                              ConteoEstado.planificado.toString(),
                            );
                      },
                      icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.blue[600],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(conteoAftProvider.notifier)
                            .updateConteoEstado(
                              conteo.id,
                              ConteoEstado.terminado.toString(),
                            );
                      },
                      icon: Icon(Icons.download, color: Colors.orange[600]),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF7F8C8D)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$d/$m/$y';
  }
}
