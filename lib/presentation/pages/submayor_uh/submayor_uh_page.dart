// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubmayorUHPage extends StatefulWidget {
  const SubmayorUHPage({super.key});

  @override
  State<SubmayorUHPage> createState() => _SubmayorUHPageState();
}

class _SubmayorUHPageState extends State<SubmayorUHPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _totalUH = 892;
  String _searchQuery = '';
  String _criterioAgrupacion = 'area';

  final List<Map<String, dynamic>> _uhList = [
    {
      'id': 'uh_001',
      'denominacion': 'ESCALERA PROFESIONAL ALUMINIO',
      'codigoProducto': '3740000012345',
      'codigoProveedor': 'PROV001',
      'areaResponsabilidad': 'MANTENIMIENTO GENERAL',
      'responsableArea': 'Carlos Mendoza Pérez',
      'custodio': 'Técnico Juan Pérez',
      'cantidad': 3,
      'estadoTecnico': '(3) Bueno en explotación',
    },
    {
      'id': 'uh_002',
      'denominacion': 'TALADRO ELÉCTRICO BOSCH',
      'codigoProducto': '3740000012346',
      'codigoProveedor': 'PROV002',
      'areaResponsabilidad': 'MANTENIMIENTO GENERAL',
      'responsableArea': 'Carlos Mendoza Pérez',
      'custodio': 'Técnico María López',
      'cantidad': 2,
      'estadoTecnico': '(2) Bueno en explotación',
    },
    {
      'id': 'uh_003',
      'denominacion': 'MARTILLO NEUMÁTICO INDUSTRIAL',
      'codigoProducto': '3740000012347',
      'codigoProveedor': 'PROV003',
      'areaResponsabilidad': 'AIRES ACONDICIONADOS INSTALACIONES',
      'responsableArea': 'Yoendrys Angel Ugando Lavin',
      'custodio': 'Técnico Carlos Ruiz',
      'cantidad': 1,
      'estadoTecnico': '(1) Regular en explotación',
    },
    {
      'id': 'uh_004',
      'denominacion': 'DESTORNILLADOR SET PROFESIONAL',
      'codigoProducto': '3740000012348',
      'codigoProveedor': 'PROV001',
      'areaResponsabilidad': 'OFICINA DE ESPECIALISTAS TÉCNICOS',
      'responsableArea': 'Maritza Sotto Oduardo',
      'custodio': 'Técnico Ana García',
      'cantidad': 5,
      'estadoTecnico': '(4) Bueno en explotación, (1) Regular en explotación',
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

  List<Map<String, dynamic>> get _filteredUH {
    return _uhList.where((uh) {
      if (_searchQuery.isEmpty) return true;
      return uh['denominacion'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          uh['codigoProducto'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          uh['areaResponsabilidad'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          uh['responsableArea'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedUH {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final uh in _filteredUH) {
      final key =
          _criterioAgrupacion == 'area'
              ? uh['areaResponsabilidad']
              : uh['responsableArea'];

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(uh);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedUH = _groupedUH;
    final filteredCount = _filteredUH.length;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/conteos-uh');
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.background,
        appBar: SearchAppBar(
          title: 'Submayor de UH',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          hasDrawer: true,
          additionalActions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.group_work, color: Colors.orange),
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
                  ],
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 16),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Total de medios: $_totalUH'
                      : 'Mostrando $filteredCount de $_totalUH medios',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: groupedUH.keys.length,
                itemBuilder: (context, index) {
                  final groupKey = groupedUH.keys.elementAt(index);
                  final groupItems = groupedUH[groupKey]!;

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
              color: Colors.orange.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _criterioAgrupacion == 'area'
                      ? Icons.location_on
                      : Icons.person,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    groupTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
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

          ...items.map((uh) => _buildUHItem(uh)),
        ],
      ),
    );
  }

  Widget _buildUHItem(Map<String, dynamic> uh) {
    return InkWell(
      onTap: () => context.push('/asset-detail/${uh['id']}'),
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
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.build, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uh['denominacion'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          uh['codigoProducto'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Cant: ${uh['cantidad']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _criterioAgrupacion == 'area'
                        ? uh['responsableArea']
                        : uh['areaResponsabilidad'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
}
