// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';
import 'package:dsimcaf_1/presentation/shared/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AreasResponsabilidadPage extends StatefulWidget {
  const AreasResponsabilidadPage({super.key});

  @override
  State<AreasResponsabilidadPage> createState() =>
      _AreasResponsabilidadPageState();
}

class _AreasResponsabilidadPageState extends State<AreasResponsabilidadPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _totalAreas = 152;
  String _searchQuery = '';
  String _criterioAgrupacion = 'centro_costo'; // 'centro_costo' o 'responsable'

  // Datos simulados de áreas
  final List<Map<String, dynamic>> _areasList = [
    {
      'id': 'area_001',
      'centroCosto': '101-Administración',
      'denominacion': 'AIRES ACONDICIONADOS INSTALACIONES',
      'codigo': '60103',
      'responsableArea': 'Yoendrys Angel Ugando Lavin',
      'cantidadAFT': 11,
      'cantidadUH': 5,
    },
    {
      'id': 'area_002',
      'centroCosto': '102-Infraestructura',
      'denominacion': 'TEATRO ZONA 5 INFRAESTRUCTURA',
      'codigo': '60102',
      'responsableArea': 'Vidalina Virgen Orozco Rodríguez',
      'cantidadAFT': 120,
      'cantidadUH': 25,
    },
    {
      'id': 'area_003',
      'centroCosto': '103-Técnica',
      'denominacion': 'OFICINA DE ESPECIALISTAS TÉCNICOS',
      'codigo': '80101',
      'responsableArea': 'Maritza Sotto Oduardo',
      'cantidadAFT': 26,
      'cantidadUH': 8,
    },
    {
      'id': 'area_004',
      'centroCosto': '104-Laboratorio',
      'denominacion': 'LABORATORIO DE ANÁLISIS QUÍMICO',
      'codigo': '50205',
      'responsableArea': 'Carlos Mendoza Pérez',
      'cantidadAFT': 15,
      'cantidadUH': 35,
    },
  ];

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

  List<Map<String, dynamic>> get _filteredAreas {
    return _areasList.where((area) {
      if (_searchQuery.isEmpty) return true;
      return area['denominacion'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          area['codigo'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          area['responsableArea'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          area['centroCosto'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedAreas {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final area in _filteredAreas) {
      final key =
          _criterioAgrupacion == 'centro_costo'
              ? area['centroCosto']
              : area['responsableArea'];

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(area);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedAreas = _groupedAreas;
    final filteredCount = _filteredAreas.length;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/verification');
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.background,
        appBar: SearchAppBar(
          title: 'Áreas de responsabilidad',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          hasDrawer: true,
          additionalActions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.group_work, color: Colors.purple),
              onSelected: (value) {
                setState(() {
                  _criterioAgrupacion = value;
                });
              },
              itemBuilder:
                  (context) => [
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
                  ],
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 16),

            // Contador de áreas
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Total de áreas: $_totalAreas'
                      : 'Mostrando $filteredCount de $_totalAreas áreas',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Lista agrupada
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: groupedAreas.keys.length,
                itemBuilder: (context, index) {
                  final groupKey = groupedAreas.keys.elementAt(index);
                  final groupItems = groupedAreas[groupKey]!;

                  return _buildGroupSection(groupKey, groupItems);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection(
    String groupTitle,
    List<Map<String, dynamic>> items,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del grupo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _criterioAgrupacion == 'centro_costo'
                      ? Icons.business
                      : Icons.person,
                  color: Colors.purple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    groupTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items del grupo
          ...items.map((area) => _buildAreaItem(area)),
        ],
      ),
    );
  }

  Widget _buildAreaItem(Map<String, dynamic> area) {
    return InkWell(
      onTap: () => context.push('/area-detail/${area['id']}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.purple,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          area['codigo'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          area['denominacion'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _criterioAgrupacion == 'centro_costo'
                        ? area['responsableArea']
                        : area['centroCosto'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildMediosStat('AFT', area['cantidadAFT'], Colors.blue),
                      const SizedBox(width: 16),
                      _buildMediosStat('UH', area['cantidadUH'], Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMediosStat(String tipo, int cantidad, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$tipo: $cantidad',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
// import 'package:dsimcaf_1/config/utils/custom_context.dart';
// import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
// import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class AreasDeResponsabilidadPage extends StatefulWidget {
//   const AreasDeResponsabilidadPage({super.key});

//   @override
//   State<AreasDeResponsabilidadPage> createState() =>
//       _AreasDeResponsabilidadPageState();
// }

// class _AreasDeResponsabilidadPageState
//     extends State<AreasDeResponsabilidadPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final int _responsibleCount = 156;
//   String _searchQuery = '';

//   void _handleSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   void _clearSearch() {
//     setState(() {
//       _searchQuery = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         if (!didPop) {
//           context.go('/verification');
//         }
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: context.background,
//         appBar: SearchAppBar(
//           title: 'Áreas de responasbilidad',
//           onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
//           onSearch: _handleSearch,
//           onSearchClear: _clearSearch,
//           hasDrawer: true,
//         ),
//         drawer: const AppDrawer(),
//         body: Column(
//           children: [
//             const SizedBox(height: 16),
//             Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3F51B5),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Text(
//                   '$_responsibleCount responsables',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: 25,
//                 itemBuilder: (context, index) {
//                   final responsableName = 'Áreas ${index + 1}';
//                   final areaId = 'area_${index + 1}';
//                   final shouldShow =
//                       _searchQuery.isEmpty ||
//                       responsableName.toLowerCase().contains(
//                         _searchQuery.toLowerCase(),
//                       );

//                   if (!shouldShow) return const SizedBox.shrink();

//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     elevation: 2,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: const Color(
//                           0xFF3F51B5,
//                         ).withOpacity(0.2),
//                         child: const Icon(
//                           Icons.people,
//                           color: Color(0xFF3F51B5),
//                         ),
//                       ),
//                       title: Text(responsableName),
//                       subtitle: Text('Áreas de responsabilidad ${index + 1}'),
//                       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onTap: () => context.push('/area-detail/$areaId'),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
