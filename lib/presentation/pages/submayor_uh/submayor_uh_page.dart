// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';
import 'package:dsimcaf_1/presentation/providers/submayor_uh/submayor_uh_provider.dart';
import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';
import 'package:dsimcaf_1/presentation/shared/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SubmayorUHPage extends ConsumerStatefulWidget {
  const SubmayorUHPage({super.key});

  @override
  ConsumerState<SubmayorUHPage> createState() => _SubmayorUHPageState();
}

class _SubmayorUHPageState extends ConsumerState<SubmayorUHPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalUH = 0;
  String _searchQuery = '';
  String _criterioAgrupacion = 'area';

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

  List<ActivoFijo> _filteredUH(List<ActivoFijo> activosFijos) {
    return activosFijos.where((uh) {
      if (_searchQuery.isEmpty) return true;
      return uh.denominacion.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          uh.nroinventario.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          uh.arearesponsabilidad.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          uh.responsable.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<ActivoFijo>> _groupedUH(List<ActivoFijo> activosFijos) {
    final grouped = <String, List<ActivoFijo>>{};

    for (final uh in activosFijos) {
      final key =
          _criterioAgrupacion == 'area'
              ? uh.arearesponsabilidad
              : uh.responsable;

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(uh);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final submayorUHState = ref.watch(submayorUHProvider);

    final activosFijosFiltrados = _filteredUH(submayorUHState.activosFijos);
    final groupedUH = _groupedUH(activosFijosFiltrados);
    final filteredCount = activosFijosFiltrados.length;
    totalUH = submayorUHState.activosFijos.length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: SearchAppBar(
        title: 'Submayor de UH',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onSearch: _handleSearch,
        onSearchClear: _clearSearch,
        hasDrawer: true,
        additionalActions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune, color: Colors.orange),
            onSelected: (value) => setState(() => _criterioAgrupacion = value),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Total de medios: $totalUH'
                      : 'Mostrando $filteredCount de $totalUH medios',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                submayorUHState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : submayorUHState.error != null &&
                        submayorUHState.error!.isNotEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            submayorUHState.error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              ref
                                  .read(submayorUHProvider.notifier)
                                  .loadActivosFijos();
                            },
                            child: Text('Volver a cargar'),
                          ),
                        ],
                      ),
                    )
                    : groupedUH.isEmpty
                    ? Center(
                      child: Text(
                        'No se encontraron activos fijos',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: groupedUH.keys.length,
                      itemBuilder: (context, index) {
                        final groupKey = groupedUH.keys.elementAt(index);
                        final groupItems = groupedUH[groupKey]!;
                        return _buildGroupSection(
                          groupKey,
                          groupItems,
                        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSection(String groupTitle, List<ActivoFijo> items) {
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
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
                      fontWeight: FontWeight.w700,
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

  Widget _buildUHItem(ActivoFijo uh) {
    return InkWell(
      onTap: () => context.push('/asset-detail/${uh.idregnumerico}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.build_circle,
                color: Colors.orange,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    uh.denominacion,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildBadge(uh.idregnumerico, Colors.blue),
                      // const SizedBox(width: 8),
                      // _buildBadge('Cant: ${uh['cantidad']}', Colors.green),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _criterioAgrupacion == 'area'
                        ? uh.responsable
                        : uh.arearesponsabilidad,
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

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
