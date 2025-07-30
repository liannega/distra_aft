// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';

// class CustomCountSelection extends StatelessWidget {
//   final String countType;
//   final VoidCallback onClose;

//   const CustomCountSelection({
//     super.key,
//     required this.countType,
//     required this.onClose,
//   });

//   void _showConfirmationDialog(
//     BuildContext context,
//     String countTypeTitle,
//     String description,
//     Map<String, String> details,
//   ) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: Text(
//               'Confirmar $countTypeTitle',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(description),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey[200]!),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Detalles del conteo:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       ...details.entries.map(
//                         (entry) => Padding(
//                           padding: const EdgeInsets.only(bottom: 4),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '• ${entry.key}: ',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   entry.value,
//                                   style: const TextStyle(color: Colors.black87),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//                 child: const Text(
//                   'Cancelar',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Cerrar diálogo
//                   onClose(); // Cerrar modal principal

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Row(
//                         children: [
//                           const Icon(Icons.check_circle, color: Colors.white),
//                           const SizedBox(width: 12),
//                           Text('$countTypeTitle iniciado correctamente'),
//                         ],
//                       ),
//                       backgroundColor: Colors.green,
//                       behavior: SnackBarBehavior.floating,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text(
//                   'Iniciar',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25),
//             topRight: Radius.circular(25),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.only(
//                 top: 20.0,
//                 left: 24.0,
//                 right: 16.0,
//                 bottom: 8.0,
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       // Volver al modal anterior
//                       showModalBottomSheet(
//                         context: context,
//                         isScrollControlled: true,
//                         backgroundColor: Colors.transparent,
//                         builder: (context) {
//                           return DraggableScrollableSheet(
//                             initialChildSize: 0.8,
//                             minChildSize: 0.6,
//                             maxChildSize: 0.95,
//                             builder: (_, scrollController) {
//                               return Material(
//                                 color: Colors.transparent,
//                                 child: Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20),
//                                       topRight: Radius.circular(20),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         margin: const EdgeInsets.only(top: 12),
//                                         width: 40,
//                                         height: 4,
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[300],
//                                           borderRadius: BorderRadius.circular(
//                                             2,
//                                           ),
//                                         ),
//                                       ),
//                                       // Aquí iría el contenido del modal anterior
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(Icons.arrow_back, size: 24),
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Conteo parcial personalizado por:',
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2C3E50),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Selecciona el criterio de personalización',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Color(0xFF7F8C8D),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.close_rounded,
//                       size: 24,
//                       color: Color(0xFF7F8C8D),
//                     ),
//                     onPressed: onClose,
//                   ),
//                 ],
//               ),
//             ),

//             Flexible(
//               child: ListView(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 16,
//                 ),
//                 children: [
//                   _buildCustomOption(
//                     context,
//                     'Área de responsabilidad',
//                     'Conteo del 100% de los medios asociados a un área de responsabilidad',
//                     Icons.location_on_outlined,
//                     const Color(0xFF4CAF50),
//                     () => _showConfirmationDialog(
//                       context,
//                       'Conteo por Área',
//                       '¿Seguro(a) que desea iniciar un conteo por área de responsabilidad?',
//                       {
//                         'Tipo de medio': 'Conteo de $countType',
//                         'Tipo de conteo':
//                             'Parcial personalizado por: Área de responsabilidad',
//                         'Área seleccionada':
//                             'AIRES ACONDICIONADOS INSTALACIONES',
//                         'Cantidad estimada': '~45 medios',
//                       },
//                     ),
//                   ),
//                   _buildCustomOption(
//                     context,
//                     'Responsable de área',
//                     'Conteo de todos los medios definidos para un responsable de área',
//                     Icons.person_outline,
//                     const Color(0xFF2196F3),
//                     () => _showConfirmationDialog(
//                       context,

//                       'Conteo por Responsable',
//                       '¿Seguro(a) que desea iniciar un conteo por responsable de área?',
//                       {
//                         'Tipo de medio': 'Conteo de $countType',
//                         'Tipo de conteo':
//                             'Parcial personalizado por: Responsable de área',
//                         'Responsable seleccionado':
//                             'Yoendrys Angel Ugando Lavin',
//                         'Cantidad estimada': '~78 medios',
//                       },
//                     ),
//                   ),
//                   _buildCustomOption(
//                     context,
//                     'Custodio de medio',
//                     'Conteo de todos los medios asignados a un custodio',
//                     Icons.security_outlined,
//                     const Color(0xFFFF9800),
//                     () => _showConfirmationDialog(
//                       context,
//                       'Conteo por Custodio',
//                       '¿Seguro(a) que desea iniciar un conteo por custodio de medio?',
//                       {
//                         'Tipo de medio': 'Conteo de $countType',
//                         'Tipo de conteo':
//                             'Parcial personalizado por: Custodio de medio',
//                         'Custodio seleccionado': 'Técnico Juan Pérez',
//                         'Cantidad estimada': '~32 medios',
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCustomOption(
//     BuildContext context,
//     String title,
//     String subtitle,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(width: 16),

//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF2C3E50),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF7F8C8D),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
