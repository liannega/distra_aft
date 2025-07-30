// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:dsimcaf_1/domain/entities/activo_fijo.dart';
import 'package:dsimcaf_1/presentation/providers/submayor_aft/submayor_aft_provider.dart';
import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';
import 'package:dsimcaf_1/presentation/shared/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SubmayorAFTPage extends ConsumerStatefulWidget {
  const SubmayorAFTPage({super.key});

  @override
  ConsumerState<SubmayorAFTPage> createState() => _SubmayorAFTPageState();
}

class _SubmayorAFTPageState extends ConsumerState<SubmayorAFTPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalAFT = 0;
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

  List<ActivoFijo> _filteredAFT(List<ActivoFijo> activosFijos) {
    return activosFijos.where((aft) {
      if (_searchQuery.isEmpty) return true;
      return aft.denominacion.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          aft.nroinventario.toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          aft.arearesponsabilidad.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          aft.responsable.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<ActivoFijo>> _groupedAFT(List<ActivoFijo> activosFijos) {
    final grouped = <String, List<ActivoFijo>>{};

    for (final aft in activosFijos) {
      final key =
          _criterioAgrupacion == 'area'
              ? aft.arearesponsabilidad
              : aft.responsable;

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(aft);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final submayorAFTState = ref.watch(submayorAFTProvider);

    final activosFijosFiltrados = _filteredAFT(submayorAFTState.activosFijos);
    final groupedAFT = _groupedAFT(activosFijosFiltrados);
    final filteredCount = activosFijosFiltrados.length;
    totalAFT = submayorAFTState.activosFijos.length;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) context.go('/verification');
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
              icon: Icon(Icons.group_work, color: context.primary),
              onSelected:
                  (value) => setState(() => _criterioAgrupacion = value),
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
                  color: context.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Total de medios: $totalAFT'
                      : 'Mostrando $filteredCount de $totalAFT medios',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child:
                  submayorAFTState.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : submayorAFTState.error != null &&
                          submayorAFTState.error!.isNotEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              submayorAFTState.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                ref
                                    .read(submayorAFTProvider.notifier)
                                    .loadActivosFijos();
                              },
                              child: Text('Volver a cargar'),
                            ),
                          ],
                        ),
                      )
                      : groupedAFT.isEmpty
                      ? Center(
                        child: Text(
                          'No se encontraron activos fijos',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: groupedAFT.keys.length,
                        itemBuilder: (context, index) {
                          final groupKey = groupedAFT.keys.elementAt(index);
                          final groupItems = groupedAFT[groupKey]!;
                          return _buildGroupSection(groupKey, groupItems)
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

  Widget _buildGroupSection(String groupTitle, List<ActivoFijo> items) {
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
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
                  color: const Color(0xFF374151),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    groupTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
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
          ...items.map((aft) => _buildAFTItem(aft)),
        ],
      ),
    );
  }

  Widget _buildAFTItem(ActivoFijo aft) {
    return InkWell(
      onTap: () => context.push('/asset-detail/${aft.idregnumerico}'),
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
                color: context.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.devices_other,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aft.denominacion,
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
                          aft.nroinventario.toString(),
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
                              ? aft.responsable
                              : aft.arearesponsabilidad,
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
