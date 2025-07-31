// ignore_for_file: deprecated_member_use
import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';
import 'package:dsimcaf_1/presentation/providers/areas-responsabilidad/areas_responsabilidad_provider.dart';
import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';
import 'package:dsimcaf_1/presentation/shared/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AreasResponsabilidadPage extends ConsumerStatefulWidget {
  const AreasResponsabilidadPage({super.key});

  @override
  ConsumerState<AreasResponsabilidadPage> createState() =>
      _AreasResponsabilidadPageState();
}

class _AreasResponsabilidadPageState
    extends ConsumerState<AreasResponsabilidadPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';
  String _criterioAgrupacion = 'area'; // 'area', 'responsable', 'centro_costo'

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  // Filtrar activos por búsqueda
  List<ActivoFijo> _filteredActivos(List<ActivoFijo> activos) {
    if (_searchQuery.isEmpty) return activos;

    return activos.where((af) {
      final query = _searchQuery.toLowerCase();
      return af.denominacion.toLowerCase().contains(query) ||
          af.idregnumerico.toLowerCase().contains(query) ||
          af.responsable.toLowerCase().contains(query) ||
          af.centrocosto.toLowerCase().contains(query) ||
          af.arearesponsabilidad.toLowerCase().contains(query);
    }).toList();
  }

  // Agrupar activos por criterio
  Map<String, dynamic> _groupedBy(List<ActivoFijo> activos) {
    final filtered = _filteredActivos(activos);
    final Map<String, dynamic> grouped = {};

    for (final af in filtered) {
      final key =
          _criterioAgrupacion == 'area'
              ? af.arearesponsabilidad
              : _criterioAgrupacion == 'responsable'
              ? af.responsable
              : af.centrocosto;

      if (key.isEmpty || key == 'null') continue;

      if (!grouped.containsKey(key)) {
        grouped[key] = {
          'area': af.arearesponsabilidad,
          'responsable': af.responsable,
          'centrocosto': af.centrocosto,
          'entidad': af.entidad,
          'activos': <ActivoFijo>[],
        };
      }
      grouped[key]['activos'].add(af);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(areasResponsabilidadProvider);
    final List<ActivoFijo> activos = state.activosFijos;
    final grouped = _groupedBy(activos);

    final int totalActivos = _filteredActivos(activos).length;
    final int totalAreas = state.areasUnicas.length;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) context.go('/verification');
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.background,
        appBar: SearchAppBar(
          title: 'Áreas de Responsabilidad',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          hasDrawer: true,
          additionalActions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort, color: Colors.purple),
              onSelected: (value) {
                setState(() {
                  _criterioAgrupacion = value;
                });
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'area',
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 20),
                          SizedBox(width: 8),
                          Text('Agrupar por área'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'responsable',
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 20),
                          SizedBox(width: 8),
                          Text('Agrupar por responsable'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'centro_costo',
                      child: Row(
                        children: [
                          Icon(Icons.business, size: 20),
                          SizedBox(width: 8),
                          Text('Agrupar por centro de costo'),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
        drawer: const AppDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF6750A4),
          foregroundColor: Colors.white,
          onPressed: () {
            context.go('/add-count');
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),

            // Contador superior
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6750A4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Total: $totalActivos medios'
                      : 'Mostrando $totalActivos de $totalAreas áreas',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Lista de áreas
            Expanded(
              child:
                  state.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : state.error != null
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: () {
                                ref
                                    .read(areasResponsabilidadProvider.notifier)
                                    .loadActivosFijos();
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                      : grouped.isEmpty
                      ? Center(
                        child: Text(
                          'No se encontraron áreas',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: grouped.keys.length,
                        itemBuilder: (context, index) {
                          final key = grouped.keys.elementAt(index);
                          final data = grouped[key];
                          return _buildAreaCard(key, data)
                              .animate()
                              .fadeIn(duration: 300.ms)
                              .slideY(begin: 0.1);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(String title, Map<String, dynamic> data) {
    final List<ActivoFijo> activos = data['activos'];
    final int cantidadAFT = activos.where((a) => a.grupo == 'AFT').length;
    final int cantidadUH = activos.where((a) => a.grupo == 'UH').length;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildStatBadge('AFT: $cantidadAFT', Colors.blue),
                    _buildStatBadge('UH: $cantidadUH', Colors.orange),
                    _buildStatBadge('Total: ${activos.length}', Colors.grey),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Entidad', data['entidad']),
                _buildDetailRow('Centro de costo', data['centrocosto']),
                _buildDetailRow('Responsable', data['responsable']),
              ],
            ),
          ),

          // Botón de acción
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: FilledButton.tonal(
              onPressed: () {},
              child: const Text('Adicionar conteo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// import 'package:dsimcaf_1/config/utils/custom_context.dart';
//   import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';
//   import 'package:dsimcaf_1/presentation/shared/search_dialog.dart';
//   import 'package:flutter/material.dart';
//   import 'package:go_router/go_router.dart';

//   class AreasResponsabilidadPage extends StatefulWidget {
//     const AreasResponsabilidadPage({super.key});

//     @override
//     State<AreasResponsabilidadPage> createState() =>
//         _AreasResponsabilidadPageState();
//   }

//   class _AreasResponsabilidadPageState extends State<AreasResponsabilidadPage> {
//     final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//     final int _totalAreas = 152;
//     String _searchQuery = '';
//     String _criterioAgrupacion = 'centro_costo'; // 'centro_costo' o 'responsable'

//     // Datos simulados de áreas
//     final List<Map<String, dynamic>> _areasList = [
//       {
//         'id': 'area_001',
//         'centroCosto': '101-Administración',
//         'denominacion': 'AIRES ACONDICIONADOS INSTALACIONES',
//         'codigo': '60103',
//         'responsableArea': 'Yoendrys Angel Ugando Lavin',
//         'cantidadAFT': 11,
//         'cantidadUH': 5,
//       },
//       {
//         'id': 'area_002',
//         'centroCosto': '102-Infraestructura',
//         'denominacion': 'TEATRO ZONA 5 INFRAESTRUCTURA',
//         'codigo': '60102',
//         'responsableArea': 'Vidalina Virgen Orozco Rodríguez',
//         'cantidadAFT': 120,
//         'cantidadUH': 25,
//       },
//       {
//         'id': 'area_003',
//         'centroCosto': '103-Técnica',
//         'denominacion': 'OFICINA DE ESPECIALISTAS TÉCNICOS',
//         'codigo': '80101',
//         'responsableArea': 'Maritza Sotto Oduardo',
//         'cantidadAFT': 26,
//         'cantidadUH': 8,
//       },
//       {
//         'id': 'area_004',
//         'centroCosto': '104-Laboratorio',
//         'denominacion': 'LABORATORIO DE ANÁLISIS QUÍMICO',
//         'codigo': '50205',
//         'responsableArea': 'Carlos Mendoza Pérez',
//         'cantidadAFT': 15,
//         'cantidadUH': 35,
//       },
//     ];

//     void _handleSearch(String query) {
//       setState(() {
//         _searchQuery = query;
//       });
//     }

//     void _clearSearch() {
//       setState(() {
//         _searchQuery = '';
//       });
//     }

//     List<Map<String, dynamic>> get _filteredAreas {
//       return _areasList.where((area) {
//         if (_searchQuery.isEmpty) return true;
//         return area['denominacion'].toLowerCase().contains(
//               _searchQuery.toLowerCase(),
//             ) ||
//             area['codigo'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
//             area['responsableArea'].toLowerCase().contains(
//               _searchQuery.toLowerCase(),
//             ) ||
//             area['centroCosto'].toLowerCase().contains(
//               _searchQuery.toLowerCase(),
//             );
//       }).toList();
//     }

//     Map<String, List<Map<String, dynamic>>> get _groupedAreas {
//       final grouped = <String, List<Map<String, dynamic>>>{};

//       for (final area in _filteredAreas) {
//         final key =
//             _criterioAgrupacion == 'centro_costo'
//                 ? area['centroCosto']
//                 : area['responsableArea'];

//         if (!grouped.containsKey(key)) {
//           grouped[key] = [];
//         }
//         grouped[key]!.add(area);
//       }

//       return grouped;
//     }

//     @override
//     Widget build(BuildContext context) {
//       final groupedAreas = _groupedAreas;
//       final filteredCount = _filteredAreas.length;

//       return PopScope(
//         canPop: false,
//         onPopInvoked: (didPop) {
//           if (!didPop) {
//             context.go('/verification');
//           }
//         },
//         child: Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: context.background,
//           appBar: SearchAppBar(
//             title: 'Áreas de responsabilidad',
//             onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
//             onSearch: _handleSearch,
//             onSearchClear: _clearSearch,
//             hasDrawer: true,
//             additionalActions: [
//               PopupMenuButton<String>(
//                 icon: const Icon(Icons.group_work, color: Colors.purple),
//                 onSelected: (value) {
//                   setState(() {
//                     _criterioAgrupacion = value;
//                   });
//                 },
//                 itemBuilder:
//                     (context) => [
//                       const PopupMenuItem(
//                         value: 'centro_costo',
//                         child: Row(
//                           children: [
//                             Icon(Icons.business, size: 20),
//                             SizedBox(width: 8),
//                             Text('Agrupar por centro de costo'),
//                           ],
//                         ),
//                       ),
//                       const PopupMenuItem(
//                         value: 'responsable',
//                         child: Row(
//                           children: [
//                             Icon(Icons.person, size: 20),
//                             SizedBox(width: 8),
//                             Text('Agrupar por responsable'),
//                           ],
//                         ),
//                       ),
//                     ],
//               ),
//             ],
//           ),
//           drawer: const AppDrawer(),
//           body: Column(
//             children: [
//               const SizedBox(height: 16),

//               // Contador de áreas
//               Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF9C27B0),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     _searchQuery.isEmpty
//                         ? 'Total de áreas: $_totalAreas'
//                         : 'Mostrando $filteredCount de $_totalAreas áreas',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Lista agrupada
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: groupedAreas.keys.length,
//                   itemBuilder: (context, index) {
//                     final groupKey = groupedAreas.keys.elementAt(index);
//                     final groupItems = groupedAreas[groupKey]!;

//                     return _buildGroupSection(groupKey, groupItems);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _buildGroupSection(
//       String groupTitle,
//       List<Map<String, dynamic>> items,
//     ) {
//       return Container(
//         margin: const EdgeInsets.only(bottom: 24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.purple.shade50,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _criterioAgrupacion == 'centro_costo'
//                         ? Icons.business
//                         : Icons.person,
//                     color: Colors.purple,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       groupTitle,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.purple,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.purple,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '${items.length}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ...items.map((area) => _buildAreaItem(area)),
//           ],
//         ),
//       );
//     }

//     Widget _buildAreaItem(Map<String, dynamic> area) {
//       return InkWell(
//         onTap: () => context.push('/area-detail/${area['id']}'),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: const BoxDecoration(
//             border: Border(
//               bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.purple.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.location_on,
//                   color: Colors.purple,
//                   size: 22,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       area['denominacion'],
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [_buildBadge(area['codigo'], Colors.deepPurple)],
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       _criterioAgrupacion == 'centro_costo'
//                           ? area['responsableArea']
//                           : area['centroCosto'],
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         _buildMediosStat('AFT', area['cantidadAFT'], Colors.blue),
//                         const SizedBox(width: 16),
//                         _buildMediosStat('UH', area['cantidadUH'], Colors.orange),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _buildBadge(String text, Color color) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.8),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       );
//     }

//     Widget _buildMediosStat(String tipo, int cantidad, Color color) {
//       return Row(
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             '$tipo: $cantidad',
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       );
//     }
//   }
