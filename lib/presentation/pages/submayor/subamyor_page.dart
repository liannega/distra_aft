// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubmayorAFTPage extends StatefulWidget {
  const SubmayorAFTPage({super.key});

  @override
  State<SubmayorAFTPage> createState() => _SubmayorAFTPageState();
}

class _SubmayorAFTPageState extends State<SubmayorAFTPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _totalAFT = 14499;
  String _searchQuery = '';
  String _criterioAgrupacion = 'area'; // 'area' o 'responsable'

  // Datos simulados de AFT
  final List<Map<String, dynamic>> _aftList = [
    {
      'id': 'aft_001',
      'denominacion': 'COMPUTADORA DE ESCRITORIO SKYLAND',
      'numeroInventario': '06754',
      'areaResponsabilidad': 'AIRES ACONDICIONADOS INSTALACIONES',
      'responsableArea': 'Yoendrys Angel Ugando Lavin',
      'serialNumber': 'SKY-2024-001',
      'estadoTecnico': 'Bueno en explotación',
    },
    {
      'id': 'aft_002',
      'denominacion': 'MONITOR 21.5 BENQ 1600X900',
      'numeroInventario': '06986',
      'areaResponsabilidad': 'AIRES ACONDICIONADOS INSTALACIONES',
      'responsableArea': 'Yoendrys Angel Ugando Lavin',
      'serialNumber': 'BENQ-2024-002',
      'estadoTecnico': 'Bueno en explotación',
    },
    {
      'id': 'aft_003',
      'denominacion': 'APC BACKUPS ES 10 OUTLET 750VA',
      'numeroInventario': '07498',
      'areaResponsabilidad': 'TEATRO ZONA 5 INFRAESTRUCTURA',
      'responsableArea': 'Vidalina Virgen Orozco Rodríguez',
      'serialNumber': 'APC-2024-003',
      'estadoTecnico': 'Regular en explotación',
    },
    {
      'id': 'aft_004',
      'denominacion': 'IMPRESORA LASER HP LASERJET',
      'numeroInventario': '07501',
      'areaResponsabilidad': 'OFICINA DE ESPECIALISTAS TÉCNICOS',
      'responsableArea': 'Maritza Sotto Oduardo',
      'serialNumber': 'HP-2024-004',
      'estadoTecnico': 'Bueno en explotación',
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

  void _handleScanOption(String option) {
    String message = '';
    switch (option) {
      case 'serial':
        message = 'Escanear código de barras o QR';
        break;
      case 'manual':
        message = 'Entrada manual de código';
        break;
      case 'scan':
        message = 'Búsqueda por escaneo';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredAFT {
    return _aftList.where((aft) {
      if (_searchQuery.isEmpty) return true;
      return aft['denominacion'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          aft['numeroInventario'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          aft['areaResponsabilidad'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          aft['responsableArea'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedAFT {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final aft in _filteredAFT) {
      final key =
          _criterioAgrupacion == 'area'
              ? aft['areaResponsabilidad']
              : aft['responsableArea'];

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(aft);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedAFT = _groupedAFT;
    final filteredCount = _filteredAFT.length;

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
          title: 'Submayor de AFT',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          onScanOption: _handleScanOption,
          hasDrawer: true,
          additionalActions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.group_work, color: Colors.blue),
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

            // Contador de medios
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Total de medios: $_totalAFT'
                      : 'Mostrando $filteredCount de $_totalAFT medios',
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
                itemCount: groupedAFT.keys.length,
                itemBuilder: (context, index) {
                  final groupKey = groupedAFT.keys.elementAt(index);
                  final groupItems = groupedAFT[groupKey]!;

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
              color: Colors.blue.withOpacity(0.1),
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
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    groupTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
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
          ...items.map((aft) => _buildAFTItem(aft)),
        ],
      ),
    );
  }

  Widget _buildAFTItem(Map<String, dynamic> aft) {
    return InkWell(
      onTap: () => context.push('/asset-detail/${aft['id']}'),
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
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.laptop, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aft['denominacion'],
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
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          aft['numeroInventario'],
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
                          _criterioAgrupacion == 'area'
                              ? aft['responsableArea']
                              : aft['areaResponsabilidad'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
}
