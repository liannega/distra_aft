
import 'package:distra_aft/config/utils/custom_context.dart';
import 'package:distra_aft/presentation/widgets/app_drawer.dart';
import 'package:distra_aft/presentation/widgets/search_dialog.dart';
import 'package:distra_aft/presentation/widgets/verification_modal.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
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
            return VerificationModal(onClose: () => Navigator.pop(context));
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.background,
      appBar: SearchAppBar(
        title: 'Verificaciones',
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
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: 'En proceso'),
                Tab(text: 'Planificadas'),
                Tab(text: 'Terminadas'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmptyState(),
                _buildEmptyState(),
                _buildEmptyState(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showVerificationModal,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustración
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset(
              'assets/images/nose.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty
                            ? 'Sin resultados\npara "$_searchQuery"'
                            : 'Ilustración\nno encontrada',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _searchQuery.isNotEmpty
                  ? 'No se encontraron verificaciones que coincidan con "$_searchQuery"'
                  : 'Usted no tiene verificaciones, por favor inicie una nueva',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: context.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
