// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:dsimcaf_1/presentation/shared/new_count_modal.dart';
import 'package:dsimcaf_1/presentation/shared/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';

class ConteoUHPage extends StatefulWidget {
  const ConteoUHPage({super.key});

  @override
  State<ConteoUHPage> createState() => _ConteoUHPageState();
}

class _ConteoUHPageState extends State<ConteoUHPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showVerificationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return NuevoConteoModal(
              onClose: () => Navigator.pop(context),
              tipoMedio: '',
            );
          },
        );
      },
    );
  }

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
    IconData icon = Icons.info;
    Color color = Colors.orange;

    switch (option) {
      case 'serial':
        message = 'Función: Escanear número de serie';
        icon = Icons.qr_code_scanner;
        color = Colors.blue;
        break;
      case 'manual':
        message = 'Función: Entrada manual de código';
        icon = Icons.keyboard;
        color = Colors.green;
        break;
      case 'scan':
        message = 'Función: Escaneo de código QR/Barras';
        icon = Icons.qr_code;
        color = Colors.purple;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder:
              (context) => ZoomIn(
                child: AlertDialog(
                  title: const Text('¿Estás seguro que quieres salir?'),
                  content: const Text('Si sales perderás el progreso actual.'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: SearchAppBar(
          title: 'Conteos UH',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          onScanOption: _handleScanOption,
          hasDrawer: true,
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            // Tabs mejorados
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF64748B),
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('En proceso'),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Planificadas'),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Terminadas'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmptyState(
                    'En proceso',
                    Icons.hourglass_empty,
                    const Color(0xFF3B82F6),
                  ),
                  _buildEmptyState(
                    'Planificadas',
                    Icons.schedule,
                    const Color(0xFF8B5CF6),
                  ),
                  _buildEmptyState(
                    'Terminadas',
                    Icons.check_circle,
                    const Color(0xFF10B981),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String tabName, IconData tabIcon, Color accentColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Contenedor de ilustración mejorado
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Patrón de fondo sutil
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.05),
                          accentColor.withOpacity(0.02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Contenido
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icono principal
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(tabIcon, size: 40, color: accentColor),
                      ),
                      const SizedBox(height: 20),
                      // Imagen o placeholder
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/nose.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Sin resultados'
                                        : 'Sin datos',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Título principal
          Text(
            _searchQuery.isNotEmpty
                ? 'Sin resultados para "$_searchQuery"'
                : 'No hay verificaciones $tabName',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 12),

          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _searchQuery.isNotEmpty
                  ? 'Intenta con otros términos de búsqueda o revisa la ortografía'
                  : _getEmptyStateDescription(tabName),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 32),

          if (_searchQuery.isEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _showVerificationModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Crear nuevo conteo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getEmptyStateDescription(String tabName) {
    switch (tabName) {
      case 'En proceso':
        return 'Cuando inicies una verificación, aparecerá aquí para que puedas continuar trabajando en ella.';
      case 'Planificadas':
        return 'Las verificaciones programadas para fechas futuras se mostrarán en esta sección.';
      case 'Terminadas':
        return 'Aquí encontrarás el historial de todas las verificaciones completadas exitosamente.';
      default:
        return 'Comienza creando tu primera verificación para ver el contenido aquí.';
    }
  }
}

