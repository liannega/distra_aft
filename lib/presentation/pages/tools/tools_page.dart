
import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _toolsCount = 892;
  String _searchQuery = '';

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
          context.go('/verification'); // Ir a página principal
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.background,
        appBar: SearchAppBar(
          title: 'Útiles y Herramientas',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          hasDrawer: true,
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 16),
            // Contador de herramientas
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF795548),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '$_toolsCount herramientas',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Lista de herramientas (simulada)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 30, // Datos de ejemplo
                itemBuilder: (context, index) {
                  final toolName = 'Herramienta #${1000 + index}';
                  final shouldShow =
                      _searchQuery.isEmpty ||
                      toolName.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );

                  if (!shouldShow) return const SizedBox.shrink();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFF795548,
                        ).withOpacity(0.2),
                        child: const Icon(
                          Icons.build,
                          color: Color(0xFF795548),
                        ),
                      ),
                      title: Text(toolName),
                      subtitle: Text(
                        'Descripción de la herramienta ${index + 1}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Acción al seleccionar una herramienta
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
