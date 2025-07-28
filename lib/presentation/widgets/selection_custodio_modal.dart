// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SeleccionCustodioModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onCustodioSeleccionado;
  final VoidCallback onClose;

  const SeleccionCustodioModal({
    super.key,
    required this.onCustodioSeleccionado,
    required this.onClose,
  });

  @override
  State<SeleccionCustodioModal> createState() => _SeleccionCustodioModalState();
}

class _SeleccionCustodioModalState extends State<SeleccionCustodioModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _custodios = [
    {
      'id': '1',
      'name': 'Técnico Juan Pérez',
      'department': 'Mantenimiento',
      'totalAssets': 15,
      'area': 'AIRES ACONDICIONADOS INSTALACIONES',
    },
    {
      'id': '2',
      'name': 'Técnico María López',
      'department': 'Sistemas',
      'totalAssets': 8,
      'area': 'AIRES ACONDICIONADOS INSTALACIONES',
    },
    {
      'id': '3',
      'name': 'Técnico Carlos Ruiz',
      'department': 'Infraestructura',
      'totalAssets': 22,
      'area': 'TEATRO ZONA 5 INFRAESTRUCTURA',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustodios =
        _custodios.where((custodio) {
          if (_searchQuery.isEmpty) return true;
          return custodio['name'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              custodio['department'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              custodio['area'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();

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
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.arrow_back, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      'Seleccionar custodio de medio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Buscador
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar custodio...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Lista de custodios
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredCustodios.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final custodio = filteredCustodios[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => widget.onCustodioSeleccionado(custodio),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.orange.withOpacity(0.1),
                              child: const Icon(
                                Icons.security,
                                color: Colors.orange,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    custodio['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${custodio['department']} - ${custodio['area']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${custodio['totalAssets']} medios en custodia',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
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
}

// import 'package:flutter/material.dart';
// import 'package:dsimcaf_1/presentation/widgets/custom_count_selection.dart';

// class CountTypeSelection extends StatelessWidget {
//   final String countType;
//   final VoidCallback onClose;

//   const CountTypeSelection({
//     super.key,
//     required this.countType,
//     required this.onClose,
//   });

//   void _showCustomCountSelection(BuildContext context) {
//     Navigator.pop(context); // Cerrar modal actual
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.8,
//           minChildSize: 0.6,
//           maxChildSize: 0.95,
//           builder: (_, scrollController) {
//             return CustomCountSelection(
//               countType: countType,
//               onClose: () => Navigator.pop(context),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showConfirmationDialog(
//     BuildContext context,
//     String countTypeTitle,
//     String description,
//     Map<String, String> details,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Text(
//           'Confirmar $countTypeTitle',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(description),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Detalles del conteo:',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   ...details.entries.map((entry) => Padding(
//                     padding: const EdgeInsets.only(bottom: 4),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '• ${entry.key}: ',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             entry.value,
//                             style: const TextStyle(color: Colors.black87),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text(
//               'Cancelar',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Cerrar diálogo
//               onClose(); // Cerrar modal principal
              
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Row(
//                     children: [
//                       const Icon(Icons.check_circle, color: Colors.white),
//                       const SizedBox(width: 12),
//                       Text('$countTypeTitle iniciado correctamente'),
//                     ],
//                   ),
//                   backgroundColor: Colors.green,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text(
//               'Iniciar',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final countOptions = [
//       {
//         'title': 'General',
//         'description': 'Conteo del 100% de los medios, para todas las áreas de responsabilidad',
//         'icon': Icons.select_all,
//         'color': const Color(0xFF4CAF50),
//         'onTap': () => _showConfirmationDialog(
//           context,
//           'Conteo General',
//           '¿Seguro(a) que desea iniciar un conteo general de todos los medios?',
//           {
//             'Tipo de medio': 'Conteo de $countType',
//             'Tipo de conteo': 'General',
//             'Centro de costo': '101-Administración',
//             'Cantidad estimada': '~1,250 medios',
//           },
//         ),
//       },
//       {
//         'title': 'Parcial mensual',
//         'description': 'Conteo planificado según el plan de conteos del mes actual',
//         'icon': Icons.calendar_month,
//         'color': const Color(0xFF2196F3),
//         'onTap': () => _showConfirmationDialog(
//           context,
//           'Conteo Parcial Mensual',
//           '¿Seguro(a) que desea iniciar el conteo parcial mensual planificado?',
//           {
//             'Tipo de medio': 'Conteo de $countType',
//             'Tipo de conteo': 'Parcial mensual',
//             'Área de responsabilidad': 'Gerencia',
//             'Mes': 'Enero 2025',
//             'Porcentaje': '10%',
//             'Cantidad estimada': '~125 medios',
//           },
//         ),
//       },
//       {
//         'title': 'Parcial personalizado',
//         'description': 'Conteo sobre criterios definidos por el usuario',
//         'icon': Icons.tune,
//         'color': const Color(0xFFFF9800),
//         'onTap': () => _showCustomCountSelection(context),
//       },
//     ];

//     return ListView.builder(
//       shrinkWrap: true,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       itemCount: countOptions.length,
//       itemBuilder: (context, index) {
//         final option = countOptions[index];
//         return Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: option['onTap'] as VoidCallback,
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: const Color(0xFFE5E5E5),
//                     width: 1,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 56,
//                       height: 56,
//                       decoration: BoxDecoration(
//                         color: (option['color'] as Color).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Icon(
//                         option['icon'] as IconData,
//                         color: option['color'] as Color,
//                         size: 28,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             option['title'] as String,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF2C3E50),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             option['description'] as String,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF7F8C8D),
//                               height: 1.3,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios_rounded,
//                       color: option['color'] as Color,
//                       size: 16,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }