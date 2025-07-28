// ignore_for_file: deprecated_member_use, unused_field

import 'package:dsimcaf_1/presentation/widgets/new_count_modal.dart';
import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConteosUHPage extends ConsumerStatefulWidget {
  const ConteosUHPage({super.key});

  @override
  ConsumerState<ConteosUHPage> createState() => _ConteosUHPageState();
}

class _ConteosUHPageState extends ConsumerState<ConteosUHPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 1; // "En proceso" por defecto
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showNuevoConteoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return NuevoConteoModal(
              tipoMedio: 'UH',
              onClose: () => Navigator.pop(context),
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: SearchAppBar(
          title: 'Conteos de UH',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          hasDrawer: true,
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            // Tabs
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
                tabs: const [
                  Tab(text: 'Planificados'),
                  Tab(text: 'En proceso'),
                  Tab(text: 'Terminados'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmptyState('Planificados', Icons.schedule, const Color(0xFF8B5CF6)),
                  _buildEmptyState('En proceso', Icons.hourglass_empty, const Color(0xFF3B82F6)),
                  _buildEmptyState('Terminados', Icons.check_circle, const Color(0xFF10B981)),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showNuevoConteoModal,
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Adicionar conteo'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String tabName, IconData tabIcon, Color accentColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tabIcon, size: 60, color: accentColor),
                const SizedBox(height: 16),
                Text(
                  'Sin conteos UH\n$tabName',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showNuevoConteoModal,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Crear nuevo conteo UH'),
          ),
        ],
      ),
    );
  }
}